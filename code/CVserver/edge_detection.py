import cv2
import numpy as np
import matplotlib.pyplot as plt

## Edge detection
def process_image(image_bytes):
    # Convert the bytes to a numpy array
    nparr = np.frombuffer(image_bytes, np.uint8)

    # Decode the numpy array into an image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    if img is None:
        raise ValueError("Could not decode image")

    y_min = 250
    y_max = 970

    # Crop the image based on y-axis thresholds
    cropped_image = img[y_min:y_max, :]
    # plt.imshow(cv2.cvtColor(cropped_image, cv2.COLOR_BGR2RGB))
    # plt.show()

    gray = cv2.cvtColor(cropped_image, cv2.COLOR_BGR2GRAY)

    # Reduce noise and improve edge detection accuracy
    blurred = cv2.GaussianBlur(gray, (5, 5), 1)
    # plt.imshow(cv2.cvtColor(blurred, cv2.COLOR_GRAY2BGR))
    # plt.show()

    edges = cv2.Canny(blurred, threshold1=30, threshold2=100)

    # plt.imshow(edges)
    # plt.show()
    morph = cv2.morphologyEx(edges, cv2.MORPH_CLOSE, np.ones((10,1),np.uint8), iterations=1)
    morph = cv2.morphologyEx(morph, cv2.MORPH_CLOSE, np.ones((1,10),np.uint8), iterations=1)

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
    eroded_mask = cv2.erode(mask, np.ones((30,30), np.uint8), iterations=1)  # Adjust iterations to control the amount of shrinking

    # Apply the mask to the cropped image
    masked_image = cv2.bitwise_and(cropped_image, cropped_image, mask=eroded_mask)
    # plt.imshow(masked_image)
    # plt.show()

    edges = cv2.Canny(masked_image, threshold1=70, threshold2=140)

    # plt.imshow(edges)
    # plt.show()

    # Find contours
    contours, _ = cv2.findContours(edges, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    # For now, I use a 'minimum area' threshold to filter small contours, but there is a better way
    min_area = 900

    contours = [cnt for cnt in contours if cv2.contourArea(cnt) > min_area]
    # print(len(contours))

    for contour in contours:
        M = cv2.moments(contour)
        if M["m00"] != 0:

            cX = int(M["m10"] / M["m00"])
            cY = int(M["m01"] / M["m00"]) + y_min
            area = cv2.contourArea(contour)
            buttons.append(["Button", cX, cY])  # Check if it is appropriate to label each coutour a button?
            # This is to draw the contours and the center points (I do it on the cropped image for now)

            cv2.drawContours(img, [contour], -1, (255, 0, 0), 2)

            cv2.circle(img, (cX, cY), 5, (0, 0, 255), -1)

    try:
        cv2.imwrite('sketch.png', img)
    except Exception as e:
        print("Failed to write image:", e)

    return buttons
