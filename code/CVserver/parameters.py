# FIXME tweak parameters using calibration

# === Calibration / Coordinates conversion ===

# filtering points outside of remote area
# measured in steps in the plotter's coordinates system
REMOTE_AREA_ORIGIN = (100, 0)  # top left
REMOTE_AREA_LIMIT = (500, 850)  # bottom right

# perspective correction

# carmera corners measured in pixels in the camera's coordinates system
# from the fake remote markers
MEASURED_CORNERS = (
    (477, 410),  # top left
    (1020, 606),  # top right
    (714, 1354),  # bottom right
    (230, 1175),  # bottom left
)

# remote plotter corners measured in steps in the plotter's coordinates system
# from the fake remote markers
ACTUAL_CORNERS = (
    (110, 10),  # top left
    (490, 10),  # top right
    (490, 840),  # bottom right
    (110, 840),  # bottom left
)
