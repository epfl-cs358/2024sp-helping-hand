import "package:helping_hand/model/config/point_2d.dart";

// FIXME tweak parameters
class Parameters {
  // Calibration
  static const remoteAreaOrigin = Point2D(x: 25, y: 215);
  static const remoteAreaLimit = Point2D(x: 328, y: 1008);

  // User Interface
  static const buttonsIncrements = [80.0, 20.0, 5.0];
}
