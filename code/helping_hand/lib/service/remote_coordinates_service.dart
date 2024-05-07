import "package:helping_hand/model/config/point_2d.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class RemoteCoordinatesService {
  // FIXME Parameters to tweak
  static const remoteAreaOrigin = Point2D(x: 0, y: 100);
  static const remoteAreaLimit = Point2D(x: 850, y: 500);

  static final remoteAreaCenter =
      remoteAreaOrigin.add(delta: remoteAreaLimit).scale(0.5);

  static final povider = Provider(
    (ref) => RemoteCoordinatesService(),
  );

  RemoteCoordinatesService();

  Point2D constrainRemoteArea(Point2D base) => base.constrain(
        min: remoteAreaOrigin,
        max: remoteAreaLimit,
      );

  // TODO coordinates conversion (config -> remote) system
}
