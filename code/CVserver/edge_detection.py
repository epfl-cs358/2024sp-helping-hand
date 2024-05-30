import cv2
import numpy as np
import matplotlib.pyplot as plt
from parameters import *


# Helper functions
def extract_second_level_contours(contours, hierarchy):
    second_level_contours = []
    # Loop over the contour indices
    for i in range(len(contours)):
        # Check if the current contour is a hole
        if hierarchy[0][i][3] != -1:
            second_level_contours.append(contours[i])

    return second_level_contours


def merge_close_contours(contours, threshold=10):
    if not contours:
        return contours

    # Calculate the centers of each contour
    centers = [np.mean(cnt, axis=0) for cnt in contours]

    # Create a list to hold merged contours
    merged_contours = []

    # Use a list to check if a contour has been merged
    merged = [False] * len(contours)

    for i in range(len(contours)):
        if not merged[i]:
            current_contour = contours[i]
            x1, y1, w1, h1 = cv2.boundingRect(current_contour)
            for j in range(i + 1, len(contours)):
                if not merged[j]:
                    x2, y2, w2, h2 = cv2.boundingRect(contours[j])
                    # Calculate distance between centers
                    distance = np.linalg.norm(
                        np.array([x1 + w1 / 2, y1 + h1 / 2]) - np.array([x2 + w2 / 2, y2 + h2 / 2]))
                    if distance < threshold:
                        # Merge contours
                        merged_contour = np.vstack((current_contour, contours[j]))
                        current_contour = merged_contour
                        merged[j] = True
            merged_contours.append(current_contour)
            merged[i] = True

    return merged_contours


def filter_contours_by_aspect_ratio_and_size(contours, aspect_ratio_threshold=0.8, min_area=50, max_area=1500):
    # Filters contours based on aspect ratio and contour area.
    # aspect_ratio_threshold: The minimum aspect ratio to consider a contour valid, set close to 1 for circular or square shapes.
    # min_area: Minimum area (in pixels) for a contour to be considered a button.
    # max_area: Maximum area (in pixels) for a contour to be considered a button.

    filtered_contours = []
    for contour in contours:
        x, y, w, h = cv2.boundingRect(contour)
        aspect_ratio = w / float(h)  # Calculate aspect ratio (width / height)
        area = cv2.contourArea(contour)  # Calculate the area of the contour

        # Check if aspect ratio and area are within acceptable ranges
        if (aspect_ratio > aspect_ratio_threshold and aspect_ratio < 1 / aspect_ratio_threshold) and (
                area > min_area and area < max_area):
            filtered_contours.append(contour)

    return filtered_contours


## Edge detection
def process_image(image_bytes):

    nparr = np.frombuffer(image_bytes, np.uint8)

    # Decode the numpy array into an image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # rotate the image
    img = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)

    if img is None:
        raise ValueError("Could not decode image")

    y_min = ACTUAL_CORNERS[0][0]
    y_max = ACTUAL_CORNERS[2][1]

    # Crop the image based on y-axis thresholds
    cropped_image = img[:, y_min:y_max]

    gray = cv2.cvtColor(cropped_image, cv2.COLOR_BGR2GRAY)

    # Reduce noise and improve edge detection accuracy
    blurred = cv2.GaussianBlur(gray, (5, 5), 1)

    plt.imshow(cv2.cvtColor(blurred, cv2.COLOR_GRAY2BGR))
    plt.show()

    # Alternative method for Canny, can't tell how it helps me now...
    #
    # median_val = np.median(blurred)
    # sigma = 0.33
    # lower = int(max(0, (1.0 - sigma) * median_val))
    # upper = int(min(255, (1.0 + sigma) * median_val))
    #
    # edges = cv2.Canny(blurred, lower, upper)

    edges = cv2.Canny(blurred, threshold1=70, threshold2=130)

    plt.imshow(edges)
    plt.show()

    morph = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, np.ones((20, 1), np.uint8), iterations=1)
    morph = cv2.morphologyEx(morph, cv2.MORPH_CLOSE, np.ones((1, 20), np.uint8), iterations=1)

    # Find contours
    contours, _ = cv2.findContours(morph, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    buttons = []

    areas = [cv2.contourArea(contour) for contour in contours]

    max_index = np.argmax(areas)
    max_contour = contours[max_index]
    max_area = areas[max_index]

    # M = cv2.moments(contour)

    mask = np.zeros_like(gray)

    # Fill the desired contour on the mask
    cv2.drawContours(mask, [max_contour], -1, 255, thickness=cv2.FILLED)

    plt.imshow(mask)
    plt.show()

    eroded_mask = cv2.erode(mask, np.ones((45, 45), np.uint8), iterations=1)

    plt.imshow(eroded_mask)
    plt.show()

    # Apply the mask to the cropped image
    masked_image = cv2.bitwise_and(cropped_image, cropped_image, mask=eroded_mask)

    plt.imshow(masked_image)
    plt.show()

    # median_val = np.median(masked_image)
    # sigma = 0.15
    # lower = int(max(0, (1.0 - sigma) * median_val))
    # upper = int(min(255, (1.0 + sigma) * median_val))
    #
    # edges = cv2.Canny(masked_image, lower, upper)

    masked_image = cv2.GaussianBlur(masked_image, (5, 5), 1)

    # Thresholds are decided based on testing
    edges = cv2.Canny(masked_image, threshold1=70, threshold2=120)

    plt.imshow(edges)
    plt.show()

    kernel_size = 5
    circular_kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (kernel_size, kernel_size))

    # Apply morphological operation using the circular kernel
    morph = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, circular_kernel, iterations=1)

    # Use cv2.RETR_CCOMP ? cv2.RETR_TREE?
    contours, hierarchy = cv2.findContours(morph, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)
    # Yet to be tested
    hole_contours = extract_second_level_contours(contours, hierarchy)

    # These are different methods I've tried to filter, but no success so far

    # contours = merge_close_contours(contours, threshold = 100)
    # contours = filter_contours_by_aspect_ratio_and_size(contours, aspect_ratio_threshold=0.4, min_area=900, max_area=20000)


    if contours:
        # For now, I use a 'minimum area' threshold to filter small contours, but there is certainly a better way
        # I use a threshold thres to filter out areas that are too close to the biggest contour, here supposing it is the remote's

        min_area = 900
        thres = 200000

        print(len(contours))

        contours = [cnt for cnt in contours if
                    cv2.contourArea(cnt) > min_area and cv2.contourArea(cnt) < max_area - thres]

        print(len(contours))

        areas = [cv2.contourArea(contour) for contour in contours]

        if areas:
            centers = []
            eps = 10

            for contour in contours:
                pop = False

                M = cv2.moments(contour)
                if M["m00"] != 0:
                    shifted_contour = contour.copy()
                    shifted_contour[:, :, 0] += y_min
                    cX = int(M["m10"] / M["m00"]) + y_min
                    cY = int(M["m01"] / M["m00"])
                    for c in centers:
                        if np.abs(cX - c[0]) < eps and np.abs(cY - c[1]) < eps:
                            pop = True
                    if pop:
                        continue
                    centers.append([cX, cY])

                    # area = cv2.contourArea(max_contour)

                    buttons.append(("Button", cX, cY))  # Check if it is appropriate to label each coutour a button?

                    # This is to draw the contours and the center points

                    # cv2.drawContours(img, contours, -1, (255, 0, 0), 2)

                    # Adjusted with the shift we get from the crop
                    cv2.drawContours(img, [shifted_contour], -1, (0, 255, 0), 2)
                    cv2.circle(img, (cX, cY), 5, (0, 0, 255), -1)
            try:
                cv2.imwrite('sketch.png', img)
            except Exception as e:
                print("Failed to write image:", e)

            print(len(centers))

            return buttons
        else:
            print("No contours with measurable area found")
    else:
        print("No contours found")


