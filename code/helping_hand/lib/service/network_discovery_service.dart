import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/state/http_client.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:http/http.dart" as http;

class NetworkDeviceService {
  static const discoveryEndpoint = "discovery-hh";

  static const configPrefix = "CAM";
  static const remotePrefix = "PLO";
  static const protocolSeparator = ",";

  static const successCode = 200;
  static const timeoutDuration = Duration(seconds: 3);

  static final povider = Provider(
    (ref) => NetworkDeviceService._(
      client: ref.watch(httpClientProvider),
    ),
  );

  final http.Client client;

  NetworkDeviceService._({
    required this.client,
  });

  Future<({String prefix, NetworkDevice network})> _deviceWithIp(
    IpAddress ipAddress,
  ) =>
      client
          .get(Uri.http(ipAddress, discoveryEndpoint))
          .timeout(timeoutDuration)
          .then((value) {
        if (value.statusCode != successCode) {
          throw Exception("Device is not available.");
        }

        final split = value.body.split(protocolSeparator);
        return (
          prefix: split[0],
          network: NetworkDevice(ipAddress: ipAddress, macAddress: split[1]),
        );
      });

  Future<NetworkDevice> _deviceWithIpPrefix(
    IpAddress ipAddress,
    String prefix,
  ) =>
      _deviceWithIp(ipAddress).then((device) {
        if (device.prefix != prefix) {
          throw Exception("Device of wrong type.");
        }

        return device.network;
      });

  Future<RemoteDevice> remoteWithIp(IpAddress ipAddress) =>
      _deviceWithIpPrefix(ipAddress, remotePrefix)
          .then((network) => RemoteDevice(network: network));

  Future<ConfigDevice> configWithIp(IpAddress ipAddress) =>
      _deviceWithIpPrefix(ipAddress, configPrefix)
          .then((network) => ConfigDevice(network: network));

  Future<bool> remoteIsOnline(RemoteDevice remote) =>
      remoteWithIp(remote.network.ipAddress)
          .then(
            (device) => remote.network.macAddress == device.network.macAddress,
          )
          .onError((error, stackTrace) => false);
}
