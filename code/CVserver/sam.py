from segment_anything import SamAutomaticMaskGenerator, sam_model_registry
import numpy as np
import cv2
import matplotlib.pyplot as plt
import pickle

POINT_DEFINITELY_ON_REMOTE = (824, 838)
REMOTE_DIM_MIN = (500, 150)
REMOTE_DIM_MAX = (1600, 700)

BUTTON_TO_REMOTE_MAX = (1/3, 4/5)

DEBUG_OUT = True
DEBUG_IN = False

def main():
    if not DEBUG_IN:
        return
    masks = restore_masks()
    filtered_masks = restore_masks('_filtered')
    image = cv2.imread('last_analyze/capture.jpg', cv2.COLOR_BGR2RGB)

    #filtered_masks = filter_masks_on_remote(masks)
    #remotes = restore_masks('_remotes')
    #for mask in filtered_masks:
    #    generate_image_overlay([mask], image, str(mask['bbox']))
        


def process_image(image_file):
    # transform image to numpy through cv2/opencv
    image = image_bytes_to_opencvimg(image_file)
    if DEBUG_OUT:
        cv2.imwrite('last_analyze/capture.jpg', image)

    masks = analyse_and_extract_masks(image)
    if DEBUG_OUT:
        save_masks(masks)
        generate_image_overlay(masks, image)

    filtered_masks = filter_masks_on_remote(masks)
    if DEBUG_OUT:
        save_masks(filtered_masks, '_filtered')
        generate_image_overlay(filtered_masks, image, '_filtered')

    buttons = masks_to_button_coordinates(masks)

    return buttons

def analyse_and_extract_masks(image):
    # load SAM model
    sam = sam_model_registry["vit_b"](checkpoint="vit_b_model.pth")
    mask_generator = SamAutomaticMaskGenerator(
        model=sam,
        #points_per_side=64,
        stability_score_thresh=0.8
    )

    # analyse image / generate masks
    masks = mask_generator.generate(image)
    print("masks generated")

    return masks

def image_bytes_to_opencvimg(img_file):
    # convert string data to numpy array
    npimg = np.fromstring(img_file, np.uint8)

    # convert numpy array to image
    img = cv2.imdecode(npimg, cv2.COLOR_BGR2RGB)
    print("image transformed to cv2 numpy")
    
    return img

def masks_to_button_coordinates(masks):
    buttons = []
    for mask in masks:
        bbox = mask['bbox']
        x = bbox[0] + bbox[2]/2
        y = bbox[1] + bbox[3]/2
        buttons.append(("button", x, y))

    return buttons

def filter_masks_on_remote(masks):
    # sort masks by size so insertion in MaskTree starts with the biggest
    masks = sorted(masks, key=(lambda x: x['area']), reverse=True)

    tree = MaskTree()
    for mask in masks:
        tree.insert(mask)

    # recursively count childs contained inside each node
    tree.count_childs()

    # find potential remotes
    remotes = tree.find_remote_suspects()
    if DEBUG_OUT:
        save_masks(remotes, '_remote_nodes')
        print(remotes)
        save_masks(list(map(lambda remote: remote.mask, remotes)), '_remotes')
    remotes = sorted(remotes, key=(lambda x: x.mask['stability_score']), reverse=True) # stability_socre could be exchanged by predicted_iou here to try if this yields better results


    if len(remotes) == 0:
        print("ERROR: no potential remote found")
        return []
    masks_of_buttons = remotes[0].get_all_rec_child_masks()
    
    # filter out too big buttons
    remote_bbox = remotes[0].mask['bbox']
    max = (remote_bbox[2]*BUTTON_TO_REMOTE_MAX[0], remote_bbox[3]*BUTTON_TO_REMOTE_MAX[1])
    masks_of_buttons = [button for button in masks_of_buttons if tree.is_smaller_than(button, max)]

    return masks_of_buttons

def generate_image_overlay(masks, image, suffix = ''):
    plt.figure(figsize=(50,50))
    plt.imshow(image)
    show_anns(masks)
    plt.axis('off')
    plt.savefig('last_analyze/annotated' + str(suffix) + '.jpg')
    plt.close()

def show_anns(anns):
    if len(anns) == 0:
        return
    sorted_anns = sorted(anns, key=(lambda x: x['area']), reverse=True)
    ax = plt.gca()
    ax.set_autoscale_on(False)

    img = np.ones((sorted_anns[0]['segmentation'].shape[0], sorted_anns[0]['segmentation'].shape[1], 4))
    img[:,:,3] = 0
    for ann in sorted_anns:
        m = ann['segmentation']
        color_mask = np.concatenate([np.random.random(3), [0.35]])
        img[m] = color_mask
    ax.imshow(img)

def save_masks(masks, suffix = ''):
    with open('last_analyze/masks' + str(suffix) + '.pkl', 'wb') as output:
        pickle.dump(masks, output, pickle.HIGHEST_PROTOCOL)

def restore_masks(suffix = ''):
    with open('last_analyze/masks' + str(suffix) + '.pkl', 'rb') as input:
        return pickle.load(input)

class MaskTreeNode(object):
    def __init__(self):
        self.mask = None
        self.childs = []
        self.child_num = 0

    def __str__(self, indent = 0):
        childs = ""
        for child in self.childs:
            childs += ((indent + 1) * "    ") + child.__str__((indent + 1)) + ", \n"
        return (indent * "    ") + "mask: " + str(self.mask['bbox']) + "#: " + str(len(self.childs)) + ", #_nested: " + str(self.child_num) + " childs: [ \n" + childs + "\n" + (indent * "    ") + "]\n"

    def get_all_rec_child_masks(self):
        masks = []
        self.get_all_rec_child_masks_rec(self, masks)
        return masks

    def get_all_rec_child_masks_rec(self, node, masks):
        for child in node.childs:
            self.get_all_rec_child_masks_rec(child, masks)
            masks.append(child.mask)

class MaskTree(object):
    def __init__(self):
        self.root = []

    def __str__(self):
        childs = ""
        for child in self.root:
            childs += str(child) + ", "
        return "root: [ " + childs + " ]"

    def insert(self, mask):
        has_childs_to_insert_to = False
        for child in self.root:
            if self.is_inside(child.mask, mask):
                has_childs_to_insert_to = True
                self.insert_rec(mask, child)
        if not has_childs_to_insert_to:
            new_node = MaskTreeNode()
            new_node.mask = mask
            self.root.append(new_node)

    def insert_rec(self, mask, node_to_insert_into):
        has_childs_to_insert_to = False
        for child in node_to_insert_into.childs:
            if self.is_inside(child.mask, mask):
                has_childs_to_insert_to = True
                self.insert_rec(mask, child)
        if not has_childs_to_insert_to:
            new_node = MaskTreeNode()
            new_node.mask = mask
            node_to_insert_into.childs.append(new_node)

    def is_inside(self, mask_to_insert_into, mask_to_insert):
        bbox_frame = mask_to_insert_into['bbox']
        bbox_insert = mask_to_insert['bbox']
        x1 = bbox_frame[0] <= bbox_insert[0]
        x2 = bbox_frame[0] + bbox_frame[2] >= bbox_insert[0] + bbox_insert[2]
        y1 = bbox_frame[1] <= bbox_insert[1]
        y2 = bbox_frame[1] + bbox_frame[3] >= bbox_insert[1] + bbox_insert[3]
        return x1 and x2 and y1 and y2
    
    def is_point_inside(self, mask_to_test, point):
        bbox = mask_to_test['bbox']
        x = bbox[0] <= point[0] and point[0] <= bbox[0] + bbox[2]
        y = bbox[1] <= point[1] and point[1] <= bbox[1] + bbox[3]
        return x and y

    def is_bigger_than(self, mask_to_test, min):
        bbox = mask_to_test['bbox']
        x = min[0] <= bbox[2]
        y = min[1] <= bbox[3]
        return x and y

    def is_smaller_than(self, mask_to_test, max):
        bbox = mask_to_test['bbox']
        x = bbox[2] <= max[0]
        y = bbox[3] <= max[1]
        return x and y
        
    def count_childs(self):
        for child in self.root:
            self.count_childs_rec(child)
    
    def count_childs_rec(self, node):
        if len(node.childs) == 0:
            node.child_num = 0
            return 1
        
        counter = 0
        for child in node.childs:
            counter += self.count_childs_rec(child)
        node.child_num = counter
        return counter + 1

    def find_remote_suspects(self):
        list = []
        for child in self.root:
            self.find_remote_suspects_rec(child, list)
        return list
    
    def find_remote_suspects_rec(self, node, list):
        if (self.is_point_inside(node.mask, POINT_DEFINITELY_ON_REMOTE)):
            if (self.is_bigger_than(node.mask, REMOTE_DIM_MIN)):
                if (node.child_num >= 3):
                    if (self.is_smaller_than(node.mask, REMOTE_DIM_MAX)):
                        list.append(node)
                for child in node.childs:
                    self.find_remote_suspects_rec(child, list)

main()