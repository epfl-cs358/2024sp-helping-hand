class RemoteConfiguration {
  static const _lineSeparator = "\n";

  final String csvConfig;

  const RemoteConfiguration.empty() : this(csvConfig: "label,x,y");

  const RemoteConfiguration({
    required this.csvConfig,
  });

  int get buttonsCount => csvConfig.allMatches(_lineSeparator).length;
  // TODO write helper methods to parse config
}
