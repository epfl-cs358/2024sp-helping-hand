import "package:helping_hand/model/network.dart";

class ConfigDevice {
  final NetworkDevice network;

  const ConfigDevice({required this.network});
}

class RemoteDevice {
  final NetworkDevice network;

  const RemoteDevice({
    required this.network,
  });

  const RemoteDevice.none()
      : this(
          network: const NetworkDevice(
            ipAddress: "",
            macAddress: "",
          ),
        );
}
