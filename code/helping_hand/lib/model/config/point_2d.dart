import "package:helping_hand/utils/types.dart";

class Point2D {
  final int x;
  final int y;

  const Point2D({
    required this.x,
    required this.y,
  });

  Point2D add({required Point2D delta}) =>
      Point2D(x: x + delta.x, y: y + delta.y);

  Point2D sub({required Point2D delta}) =>
      Point2D(x: x - delta.x, y: y - delta.y);

  Point2D scale([double scale = 1]) => Point2D(
        x: (x * scale).round(),
        y: (y * scale).round(),
      );

  Point2D constrain({
    required Point2D min,
    required Point2D max,
  }) =>
      Point2D(
        x: clampInt(min.x, x, max.x),
        y: clampInt(min.y, y, max.y),
      );

  Map<String, String> queryParams() => {
        "x": x.toString(),
        "y": y.toString(),
      };
}
