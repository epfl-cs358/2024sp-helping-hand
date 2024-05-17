import "package:helping_hand/model/config/point_2d.dart";

// FIXME tweak parameters
class Parameters {
  // Calibration
  static const remoteAreaOrigin = Point2D(x: 100, y: 0);
  static const remoteAreaLimit = Point2D(x: 500, y: 850);

  // User Interface
  static const buttonsIncrements = [80.0, 20.0, 5.0];
}
