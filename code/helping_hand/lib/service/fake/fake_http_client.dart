import "package:helping_hand/model/network.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:http/http.dart" as http;

class FakeHttpClient extends http.BaseClient {
  static const _subnet = 1;

  static const _fakeCamsId = [200];
  static const _fakeRemotesId = [32, 121];

  final _fakeCams =
      _fakeCamsId.map((id) => NetworkDevice(subnet: _subnet, id: id));
  final _fakeRemotes =
      _fakeRemotesId.map((id) => NetworkDevice(subnet: _subnet, id: id));

  _answerWith(String response) => http.StreamedResponse(
        Stream.value(response.codeUnits),
        NetworkDiscoveryService.successCode,
      );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    final url = request.url.toString();

    for (final (i, cam) in _fakeCams.indexed) {
      if (url.contains(cam.ipAddress) &&
          url.contains(NetworkDiscoveryService.discoveryEndpoint)) {
        return _answerWith(
            "${NetworkDiscoveryService.configPrefix},config_mac_$i");
      }
    }

    for (final (i, remote) in _fakeRemotes.indexed) {
      if (url.contains(remote.ipAddress) &&
          url.contains(NetworkDiscoveryService.discoveryEndpoint)) {
        return _answerWith(
            "${NetworkDiscoveryService.remotePrefix},remote_mac_$i");
      }
    }

    throw Exception("Cannot reach device.");
  }
}
