from segment_anything import SamAutomaticMaskGenerator, sam_model_registry
import numpy as np
import cv2


def process_image(image_file):
    masks = analyse_and_extract_masks(image_file)
    
    csv_data = convert_coco_masks_to_button_coordinates_csv(mask)


    return csv_data


def analyse_and_extract_masks(image_file):
    # transform image to numpy through cv2/opencv
    image = image_bytes_to_opencvimg(image_file)

    # load SAM model
    sam = sam_model_registry["vit_b"](checkpoint="vit_b_model.pth")
    mask_generator = SamAutomaticMaskGenerator(sam)

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

def convert_coco_masks_to_button_coordinates_csv(mask):
    csv_data = mask # TODO: actually convert coco masks to our csv format
    return csv_data
