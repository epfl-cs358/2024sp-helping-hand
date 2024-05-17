import cv2
import numpy as np
from parameters import *


perspective_matrix = cv2.getPerspectiveTransform(
    np.float32(MEASURED_CORNERS),
    np.float32(ACTUAL_CORNERS)
)


def _camera_to_plotter(x, y):
    # Convert to homogeneous coordinates
    src_point = np.array([x, y, 1], dtype=np.float32)

    # Apply perspective transformation
    res_point = perspective_matrix @ src_point

    return int(res_point[0] / res_point[2]), int(res_point[1] / res_point[2])


def _is_inside_remote_area(button):
    point = button[1:]

    for axis in range(len(point)):
        coord = point[axis]
        if REMOTE_AREA_ORIGIN[axis] > coord or coord > REMOTE_AREA_LIMIT[axis]:
            return False

    return True


def buttons_coordinates(buttons, filtered=True):
    """
    Maps a list of points from pixel coordinates to plotter coordinates.
    Performs the perspective correction algorithm.
    Filters out points outside of the remote area.
    """

    # change coordinates
    mapped_points = [
        (label, *_camera_to_plotter(x, y))
        for label, x, y in buttons
    ]

    # filter inside the remote area
    if filtered:
        mapped_points = list(filter(_is_inside_remote_area, mapped_points))

    return mapped_points
