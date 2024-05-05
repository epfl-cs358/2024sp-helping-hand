import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/data/remote_data.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/network.dart";

class SavedRemote {
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
}
