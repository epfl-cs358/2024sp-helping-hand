import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/data/remote_data.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/network.dart";

class SavedRemote implements Comparable<SavedRemote> {
  final String name;
  final RemoteConfiguration config;
  final RemoteDevice device;
  final bool isOnline;

  const SavedRemote({
    required this.name,
    required this.config,
    required this.device,
    required this.isOnline,
  });

  factory SavedRemote.fromSerialized(String remoteData) {
    final split = remoteData.split(RemoteConfiguration.lineSeparator).toList();

    final device = RemoteDevice(
      network: NetworkDevice(
        macAddress: split[1],
        ipAddress: split[2],
      ),
    );

    final configData = split.skip(3).join(RemoteConfiguration.lineSeparator);
    final remoteConfig = RemoteConfiguration.fromSerialized(configData);

    return SavedRemote(
      name: split[0],
      device: device,
      config: remoteConfig,
      isOnline: false,
    );
  }

  RemoteData data() => RemoteData(
        name: name,
        config: config.csvConfig,
        ipAddress: device.network.ipAddress,
      );

  SavedRemote withArgs({
    String? name,
    RemoteConfiguration? config,
    NetworkDevice? network,
  }) =>
      SavedRemote(
        name: name ?? this.name,
        config: config ?? this.config,
        device: network != null ? RemoteDevice(network: network) : device,
        isOnline: isOnline,
      );

  String serialize() =>
      "$name${RemoteConfiguration.lineSeparator}${device.network.macAddress}${RemoteConfiguration.lineSeparator}${device.network.ipAddress}${RemoteConfiguration.lineSeparator}${config.csvConfig}";

  @override
  int compareTo(SavedRemote other) {
    // online remotes first
    if (isOnline != other.isOnline) {
      return isOnline ? -1 : 1;
    }

    // order by mac address (fixed ordering)
    return device.network.macAddress.compareTo(other.device.network.macAddress);
  }
}
