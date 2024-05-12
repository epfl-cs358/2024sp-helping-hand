import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:helping_hand/model/config/button.dart";
import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/config/point_2d.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/service/automatic_config_service.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/service/remote_controller_service.dart";
import "package:http/http.dart" as http;

class FakeHttpClient extends http.BaseClient {
  static const _fakeHttpDelay = Duration(seconds: 1);
  static const _fakeMovementDelay = Duration(milliseconds: 500);

  static const _baseFakeIp = "192.168.1.";

  static const _fakeRemotesId = [1, 2];
  static const _fakeConfigId = [3];

  static final _fakeRemotes = _fakeRemotesId.map(
    (id) => NetworkDevice(
      ipAddress: "$_baseFakeIp$id",
      macAddress: "0:1:$id",
    ),
  );
  static final _fakeCams = _fakeConfigId.map(
    (id) => NetworkDevice(
      ipAddress: "$_baseFakeIp$id",
      macAddress: "0:2:$id",
    ),
  );

  static const _fakeCvServer = "${_baseFakeIp}4";

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

      if (url.contains(cam.ipAddress) &&
          url.contains(AutomaticConfigService.configPictureEndpoint)) {
        final fakeImage = await rootBundle.load("assets/default_image.jpg");

        return http.StreamedResponse(
          Stream.value(fakeImage.buffer.asInt8List()),
          NetworkDeviceService.successCode,
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

    if (url.contains(_fakeCvServer) &&
        url.contains(AutomaticConfigService.cvServerConfigEndopint)) {
      final defaultConfig = RemoteConfiguration.fromButtons([
        const Button(
          label: "my test button 1",
          pos: Point2D(x: 10, y: 15),
        ),
        const Button(
          label: "my test button 2",
          pos: Point2D(x: 40, y: 50),
        ),
      ]);

      return _answerWith(defaultConfig.csvConfig);
    }

    throw Exception("Cannot reach device.");
  }
}
