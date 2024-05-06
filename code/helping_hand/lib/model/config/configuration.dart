import "package:helping_hand/model/config/button.dart";
import "package:helping_hand/model/config/point_2d.dart";

class RemoteConfiguration {
  static const lineSeparator = "\n";
  static const dataSeparator = ",";

  static const _header = "label,x,y";

  final String csvConfig;

  const RemoteConfiguration.empty() : this(csvConfig: _header);

  const RemoteConfiguration({
    required this.csvConfig,
  });

  factory RemoteConfiguration.fromSerialized(String configData) {
    final lines = configData.split(lineSeparator);
    if (lines.first != _header) {
      throw const FormatException("Config does not start with header.");
    }

    // Check for config errors using identity button encode/decode
    final config = RemoteConfiguration.fromButtons(
      RemoteConfiguration(csvConfig: configData).buttons,
    );

    return config;
  }

  factory RemoteConfiguration.fromButtons(List<Button> buttons) {
    final lines = buttons.map((b) => b.toConfigLine()).toList();
    lines.insert(0, _header);
    final config = lines.join(lineSeparator);

    return RemoteConfiguration(csvConfig: config);
  }

  int get buttonsCount => csvConfig.allMatches(lineSeparator).length;

  List<Button> get buttons =>
      csvConfig.split(lineSeparator).skip(1).map((line) {
        final split = line.split(dataSeparator);
        return Button(
          label: split[0],
          pos: Point2D(
            x: int.parse(split[1]),
            y: int.parse(split[2]),
          ),
        );
      }).toList();

  RemoteConfiguration withNewButton(Button button) {
    final lines = csvConfig.split(lineSeparator);
    lines.insert(1, button.toConfigLine());
    final newConfig = lines.join(lineSeparator);
    return RemoteConfiguration(csvConfig: newConfig);
  }
}
