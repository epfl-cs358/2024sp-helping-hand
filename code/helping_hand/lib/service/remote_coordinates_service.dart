import "package:helping_hand/model/config/point_2d.dart";
import "package:helping_hand/static/parameters.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class RemoteCoordinatesService {
  static final remoteAreaCenter = Parameters.remoteAreaOrigin
      .add(delta: Parameters.remoteAreaLimit)
      .scale(0.5);

  static final povider = Provider(
    (ref) => RemoteCoordinatesService(),
  );

  RemoteCoordinatesService();

  Point2D constrainRemoteArea(Point2D base) => base.constrain(
        min: Parameters.remoteAreaOrigin,
        max: Parameters.remoteAreaLimit,
      );
}
