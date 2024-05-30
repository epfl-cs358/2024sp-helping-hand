# FIXME tweak parameters using calibration

# === Calibration / Coordinates conversion ===

# filtering points outside of remote area
# measured in steps in the plotter's coordinates system
REMOTE_AREA_ORIGIN = (22, 123)  # top left
REMOTE_AREA_LIMIT = (374, 953)  # bottom right

# perspective correction

# camera corners measured in pixels in the camera's coordinates system
# from the fake remote markers
MEASURED_CORNERS = (
    (345, 96),  # top left
    (832, 90),  # top right
    (849, 1344),  # bottom right
    (352, 1349),  # bottom left
)

# remote plotter corners measured in steps in the plotter's coordinates system
# from the fake remote markers
ACTUAL_CORNERS = (
    (42, 143),  # top left
    (354, 140),  # top right
    (354, 933),  # bottom right
    (44, 933),  # bottom left
)

# === Edge detection parameters ===
