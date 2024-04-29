import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/service/fake/fake_http_client.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:http/http.dart" as http;
import "package:stream_transform/stream_transform.dart";

class NetworkDiscoveryService {
  static const discoveryEndpoint = "discovery-hh";

  static const configPrefix = "CAM";
  static const remotePrefix = "PLO";
  static const protocolSeparator = ",";

  static const subnet = 1;
  static const maxId = 256;

  static const successCode = 200;
  static const timeoutDuration = Duration(seconds: 2);

  final http.Client client;

  NetworkDiscoveryService({
    required this.client,
  });

  Stream<NetworkDevice> _candidateDevices() async* {
    for (var id = 0; id < maxId; id++) {
      yield NetworkDevice(subnet: subnet, id: id);
    }
  }

  Stream<ActiveLanDevice> _prefixDevices(String prefix) => _candidateDevices()
      .concurrentAsyncMap((candidate) async => (
            device: candidate,
            response: await client
                .get(candidate.uri.resolve(discoveryEndpoint))
                .timeout(timeoutDuration),
          ))
      .handleError((_) {})
      .where((e) =>
          e.response.statusCode == successCode &&
          e.response.body.startsWith(prefix))
      .map((e) => ActiveLanDevice(
            lan: e.device,
            macAddress: e.response.body.split(protocolSeparator)[1],
          ));

  Future<ConfigDevice> getLocalConfigDevice() async =>
      _prefixDevices(configPrefix)
          .map((value) => ConfigDevice(network: value))
          .first;

  Future<List<RemoteDevice>> getLocalRemoteDevices() async =>
      _prefixDevices(remotePrefix)
          .map((value) => RemoteDevice(network: value))
          .toList();
}

final discoveryServiceProvider = Provider(
  (ref) => NetworkDiscoveryService(
    client: FakeHttpClient(),
    // client: http.Client(),
  ),
);
