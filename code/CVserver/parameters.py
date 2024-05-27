# FIXME tweak parameters using calibration

# === Calibration / Coordinates conversion ===

# filtering points outside of remote area
# measured in steps in the plotter's coordinates system
REMOTE_AREA_ORIGIN = (20, 200)  # top left
REMOTE_AREA_LIMIT = (360, 1020)  # bottom right

# perspective correction

# carmera corners measured in pixels in the camera's coordinates system
# from the fake remote markers
MEASURED_CORNERS = (
    (372, 248),  # top left
    (806, 246),  # top right
    (814, 1354),  # bottom right
    (378, 1358),  # bottom left
)

# remote plotter corners measured in steps in the plotter's coordinates system
# from the fake remote markers
ACTUAL_CORNERS = (
    (35, 189),  # top left
    (345, 188),  # top right
    (344, 1010),  # bottom right
    (33, 1011),  # bottom left
)

# === Edge detection parameters ===
