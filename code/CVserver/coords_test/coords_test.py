import cv2
import numpy as np
from parameters import *


def change_pixel_color(image_path, points, size=5):
    image = cv2.imread(image_path)
    if image is None:
        print("Image not found or unable to read")
        return
    red_color = (0, 0, 255)

    half_size = size // 2
    for point in points:
        x, y = point
        for dx in range(-half_size, half_size + 1):
            for dy in range(-half_size, half_size + 1):
                nx, ny = x + dx, y + dy
                if 0 <= nx < image.shape[1] and 0 <= ny < image.shape[0]:
                    image[ny, nx] = red_color

    cv2.imwrite('modified_img.png', image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


image_path = 'fake_remote.jpg'

points = MEASURED_CORNERS

change_pixel_color(image_path, points)
