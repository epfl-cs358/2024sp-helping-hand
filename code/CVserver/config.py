from coordinates import buttons_coordinates

# Simply change below from which file you import the `process_image` function
# to change which algorithm to use to get buttons from an image.
#
# A `process_image` function takes a list of bytes as input (raw image data)
# and returns a list of tuples of the form (label, x_coord, y_coord).
# Each tuple represents a remote button on the image.
# Coordinates `x_coord` and `y_coord` must be integers (`int`) and are
# in values in pixels from the image's coordinates system (origin top left).
#
# Currently available algorithms (python files):
#     - edge_detection

#from edge_detection import process_image
from sam import process_image

CSV_SEPARATOR = ","
CSV_NEWLINE = "\n"
CSV_HEADER = f"label{CSV_SEPARATOR}x{CSV_SEPARATOR}y"


def image_to_config(img_data):
    # computer vision buttons identification
    buttons = process_image(img_data)

    # change coordinates
    # TODO enable filtering when measurements done
    buttons = buttons_coordinates(buttons, filtered=False)

    # generate config
    points_config = [
        CSV_SEPARATOR.join(map(str, button))
        for button in buttons
    ]

    config = CSV_NEWLINE.join([CSV_HEADER, *points_config])

    return config
