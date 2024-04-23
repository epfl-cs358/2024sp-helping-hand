import cv2
import csv
import numpy as np
from io import StringIO


def process_image(image_bytes):
    # Load image and convert to grayscale
    # img = cv2.imread(image_path)
    # Convert the bytes to a numpy array
    nparr = np.frombuffer(image_bytes, np.uint8)
    # Decode the numpy array into an image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    if img is None:
        raise ValueError("Could not decode image")


    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Reduce noise and improve edge detection accuracy
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    # Perform edge detection
    edges = cv2.Canny(blurred, threshold1=30, threshold2=100)

    # Find contours
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # CSV file
    si = StringIO()
    cw = csv.writer(si)
    cw.writerow(['label', 'x', 'y'])

    # Calculate the center point for each contour and write to CSV file
    for contour in contours:
        M = cv2.moments(contour)
        if M["m00"] != 0:
            cX = int(M["m10"] / M["m00"])
            cY = int(M["m01"] / M["m00"])
            cw.writerow(["Button", cX, cY])  # Check if it is appropriate to label each coutour a button?
            # This is to draw the contours and the center points
            cv2.drawContours(img, [contour], -1, (0, 255, 0), 2)
            cv2.circle(img, (cX, cY), 5, (255, 0, 0), -1)

    # This is to optionally show the image with the contours and the center  points
    # cv2.imshow("Image", img)
    # cv2.waitKey(0)
    # cv2.destroyAllWindows()
    cv2.imwrite('sketch.png', img)

    si.seek(0)
    return si.getvalue()

