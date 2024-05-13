import matplotlib.pyplot as plt
import matplotlib.image as mpimg

# relative import the coordinates module
import sys
sys.path.append("..")

from coordinates import *


MARKERS_FILE = "markers.jpg"

# test points measured in pixels in the camera's coordinates
TEST_POINTS = (
    (726, 533),
    (609, 906),
    (307, 1142),
    (1174, 1522),
)


def _display_corners(ax, corners, corners_color="r", polygon_color="b"):
    # show corners
    for x, y in corners:
        ax.plot(x, y, corners_color + "o")

    # show corners polygon
    polygon = list(corners)
    polygon.append(polygon[0])
    X, Y = zip(*polygon)
    ax.plot(X, Y, polygon_color)


def show_markers(ax, image_file, corners):
    # show markers image
    img = mpimg.imread(image_file)
    ax.imshow(img)

    # show measured_corners
    _display_corners(ax, corners, "r", "b")


def show_plotter_area(ax, origin, limit, corners):
    # remote area limit
    remote_area_corners = (
        origin,
        (limit[0], origin[1]),
        limit,
        (origin[0], limit[1]),
    )

    _display_corners(ax, remote_area_corners, "k", "k")
    # markers delimitation in plotters coordinates
    _display_corners(ax, corners, "g", "g")


def show_points_conversion(camera_ax, plotter_ax, points):
    cmap = plt.get_cmap("viridis", len(points))

    # camera points
    for i, (x, y) in enumerate(points):
        camera_ax.plot(x, y, "o", color=cmap(i))

    # plotter points (fake buttons with empty label)
    test_buttons = [("", *coords) for coords in points]
    converted_points = buttons_coordinates(test_buttons)
    for i, (_, x, y) in enumerate(converted_points):
        plotter_ax.plot(x, y, "o", color=cmap(i))


def main():
    _, (left, right) = plt.subplots(1, 2)

    # origin to top left
    left.invert_yaxis()
    right.invert_yaxis()
    left.set_aspect("equal")
    right.set_aspect("equal")

    show_markers(left, MARKERS_FILE, MEASURED_CORNERS)
    show_plotter_area(right, REMOTE_AREA_ORIGIN, REMOTE_AREA_LIMIT, ACTUAL_CORNERS)
    show_points_conversion(left, right, TEST_POINTS)

    plt.show()


if __name__ == "__main__":
    main()
