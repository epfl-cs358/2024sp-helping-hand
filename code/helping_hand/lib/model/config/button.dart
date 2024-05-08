import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/config/point_2d.dart";

class Button {
  final String label;
  final Point2D pos;

  const Button({
    required this.label,
    required this.pos,
  });

  String toConfigLine() =>
      "$label${RemoteConfiguration.dataSeparator}${pos.x}${RemoteConfiguration.dataSeparator}${pos.y}";

  Button withArgs({String? label, Point2D? pos}) => Button(
        label: label ?? this.label,
        pos: pos ?? this.pos,
      );
}
