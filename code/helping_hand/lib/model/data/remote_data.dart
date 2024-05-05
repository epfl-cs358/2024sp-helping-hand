class RemoteData {
  static const nameCollectionSuffix = "_name";
  static const configCollectionSuffix = "_config";
  static const ipAddressCollectionSuffix = "_ip";

  final String name;
  final String config;
  final String ipAddress;

  const RemoteData({
    required this.name,
    required this.config,
    required this.ipAddress,
  });
}
