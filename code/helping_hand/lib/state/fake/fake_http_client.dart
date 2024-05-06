import "package:flutter/foundation.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/service/remote_controller_service.dart";
import "package:http/http.dart" as http;

class FakeHttpClient extends http.BaseClient {
  static const _fakeHttpDelay = Duration(seconds: 1);
  static const _fakeMovementDelay = Duration(milliseconds: 500);

  static const _fakeRemotesId = [1, 2];
  static const _fakeConfigId = [3];

  static final _fakeRemotes = _fakeRemotesId.map(
    (id) => NetworkDevice(
      ipAddress: "192.168.1.$id",
      macAddress: "0:1:$id",
    ),
  );
  static final _fakeCams = _fakeConfigId.map(
    (id) => NetworkDevice(
      ipAddress: "192.168.1.$id",
      macAddress: "0:2:$id",
    ),
  );

  _answerWith(String response) => http.StreamedResponse(
        Stream.value(response.codeUnits),
        NetworkDeviceService.successCode,
      );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final url = request.url.toString();

    if (kDebugMode) {
      print(url);
    }

    await Future.delayed(_fakeHttpDelay);

    for (final cam in _fakeCams) {
      if (url.contains(cam.ipAddress) &&
          url.contains(NetworkDeviceService.discoveryEndpoint)) {
        return _answerWith(
          "${NetworkDeviceService.configPrefix},${cam.macAddress}",
        );
      }
    }

    for (final remote in _fakeRemotes) {
      if (url.contains(remote.ipAddress) &&
          url.contains(NetworkDeviceService.discoveryEndpoint)) {
        return _answerWith(
          "${NetworkDeviceService.remotePrefix},${remote.macAddress}",
        );
      }

      if (url.contains(RemoteControllerService.moveEndpoint) ||
          url.contains(RemoteControllerService.moveOutEndpoint)) {
        await Future.delayed(_fakeMovementDelay);
        return _answerWith("");
      }

      if (url.contains(RemoteControllerService.shortPressEndoint)) {
        return _answerWith("");
      }
    }

    throw Exception("Cannot reach device.");
  }
}
