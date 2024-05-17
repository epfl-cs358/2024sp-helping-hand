import cv2
import numpy as np


## These are helper functions to help close an almost closed contour
def is_almost_closed(contour, closure_threshold=20):
    # Check if the first and last points of the contour are close enough
    if len(contour) < 2:
        return False
    # Calculate the distance between the first and last point
    first_point = contour[0][0]
    last_point = contour[-1][0]
    distance = np.linalg.norm(first_point - last_point)
    return distance < closure_threshold


def filter_contours(contours):
    filtered_contours = []
    for contour in contours:
        # Simplify contour to potentially close small gaps
        epsilon = 0.01 * cv2.arcLength(contour, True)
        approx = cv2.approxPolyDP(contour, epsilon, True)

        # Check if the contour is "almost closed" and has a reasonable area
        if is_almost_closed(approx) and cv2.contourArea(approx) > 100:
            filtered_contours.append(approx)

    return filtered_contours

## Edge detection
def process_image(image_bytes):
    # Convert the bytes to a numpy array
    nparr = np.frombuffer(image_bytes, np.uint8)
    # Decode the numpy array into an image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    if img is None:
        raise ValueError("Could not decode image")

    # img_yuv = cv2.cvtColor(img, cv2.COLOR_BGR2YUV)
    # clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
    # img_yuv[:, :, 0] = clahe.apply(img_yuv[:, :, 0])
    # img = cv2.cvtColor(img_yuv, cv2.COLOR_YUV2BGR)
    #
    # gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    # edges = cv2.Canny(blurred, threshold1=50, threshold2=150)  # Adjusted thresholds
    #
    # contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)


    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Reduce noise and improve edge detection accuracy
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    # Perform edge detection
    edges = cv2.Canny(blurred, threshold1=30, threshold2=50)


    # Find contours
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    filtered_contours = filter_contours(contours)

    # filtered_contours = []
    # for contour in contours:
    #     # Simplify contour to reduce noise
    #     epsilon = 0.01 * cv2.arcLength(contour, True)
    #     approx = cv2.approxPolyDP(contour, epsilon, True)
    #
    #     # Check if the contour is convex and has a reasonable area
    #     if cv2.isContourConvex(approx) and cv2.contourArea(approx) > 100:
    #         filtered_contours.append(approx)

    # Result
    buttons = []


    # Calculate the center point for each contour and write to CSV file
    for contour in filtered_contours:
        M = cv2.moments(contour)
        if M["m00"] != 0:
            cX = int(M["m10"] / M["m00"])
            cY = int(M["m01"] / M["m00"])
            buttons.append(["Button", cX, cY])  # Check if it is appropriate to label each coutour a button?
            # This is to draw the contours and the center points
            cv2.drawContours(img, [contour], -1, (0, 255, 0), 2)
            cv2.circle(img, (cX, cY), 5, (255, 0, 0), -1)

    try:
        cv2.imwrite('sketch.png', img)
    except Exception as e:
        print("Failed to write image:", e)

    return buttons
