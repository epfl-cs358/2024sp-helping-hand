import cv2
import numpy as np
import matplotlib.pyplot as plt
from parameters import *

## Edge detection
def process_image(image_bytes):
    # Convert the bytes to a numpy array
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

    edges = cv2.Canny(blurred, threshold1=70, threshold2=130)

    plt.imshow(edges)
    plt.show()
    morph = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, np.ones((20,1),np.uint8), iterations=1)
    morph = cv2.morphologyEx(morph, cv2.MORPH_CLOSE, np.ones((1,20),np.uint8), iterations=1)

    # Find contours
    contours, _ = cv2.findContours(morph, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)


    buttons = []

    # Calculate the center point for each contour and write to CSV file
    areas = [cv2.contourArea(contour) for contour in contours]
    max = np.argmax(areas)
    contour = contours[max]

    # M = cv2.moments(contour)

    mask = np.zeros_like(gray)

    # Fill the desired contour on the mask
    cv2.drawContours(mask, [contour], -1, 255, thickness=cv2.FILLED)
    plt.imshow(mask)
    plt.show()
    eroded_mask = cv2.erode(mask, np.ones((40,40), np.uint8), iterations=1)  # Adjust iterations to control the amount of shrinking
    plt.imshow(eroded_mask)
    plt.show()
    # Apply the mask to the cropped image
    masked_image = cv2.bitwise_and(cropped_image, cropped_image, mask=eroded_mask)
    plt.imshow(masked_image)
    plt.show()

    edges = cv2.Canny(masked_image, threshold1=70, threshold2=120)

    plt.imshow(edges)
    plt.show()

    kernel_size = 5
    circular_kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (kernel_size, kernel_size))

    # Apply morphological operation using the circular kernel
    morph = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, circular_kernel, iterations=1)

    # Find contours
    # Use cv2.RETR_CCOMP ? cv2.RETR_TREE?
    contours, _ = cv2.findContours(morph, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    # For now, I use a 'minimum area' threshold to filter small contours, but there is a better way
    min_area = 900

    contours = [cnt for cnt in contours if cv2.contourArea(cnt) > min_area]
    print(len(contours))
    areas = [cv2.contourArea(contour) for contour in contours]
    max = np.argmax(areas)
    contours.pop(max)
    print(len(contours))
    for contour in contours:
        M = cv2.moments(contour)
        if M["m00"] != 0:

            cX = int(M["m10"] / M["m00"]) + y_min
            cY = int(M["m01"] / M["m00"])
            area = cv2.contourArea(contour)
            buttons.append(["Button", cX, cY])  # Check if it is appropriate to label each coutour a button?
            # This is to draw the contours and the center points (I do it on the cropped image for now)

            cv2.drawContours(img, [contour], -1, (0, 255, 0), 2)

            cv2.circle(img, (cX, cY), 5, (0, 0, 255), -1)

    try:
        cv2.imwrite('sketch.png', img)
    except Exception as e:
        print("Failed to write image:", e)

    return buttons
