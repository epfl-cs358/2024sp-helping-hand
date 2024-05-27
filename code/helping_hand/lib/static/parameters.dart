import "package:helping_hand/model/config/point_2d.dart";

// FIXME tweak parameters
class Parameters {
  // Calibration
  static const remoteAreaOrigin = Point2D(x: 0, y: 0);
  static const remoteAreaLimit = Point2D(x: 380, y: 1020);

  // User Interface
  static const buttonsIncrements = [80.0, 20.0, 5.0];
  // static const buttonsIncrements = [80.0, 5.0, 1.0];
}
