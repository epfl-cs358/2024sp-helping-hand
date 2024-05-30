import "dart:convert";

import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/state/http_client.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:http/http.dart" as http;

class AutomaticConfigService {
  static const configPictureEndpoint = "capture";

  static const cvServerConfigEndopint = "analyse";
  static final cvServerUri = Uri.http(
    "192.168.225.143:5005",
    cvServerConfigEndopint,
  );

  static const timeoutDuration = Duration(seconds: 5);
  static const timeoutCvServer = Duration(minutes: 5);

  static final povider = Provider<AutomaticConfigService>(
    (ref) => AutomaticConfigService._(
      client: ref.watch(httpClientProvider),
    ),
  );

  AutomaticConfigService._({
    required this.client,
  });

  final http.Client client;

  Future<String> _requestPicture(ConfigDevice configDevice) async {
    final captureUri = Uri.http(
      configDevice.network.ipAddress,
      configPictureEndpoint,
    );

    final response = await client.get(captureUri).timeout(timeoutDuration);
    if (response.statusCode != NetworkDeviceService.successCode) {
      throw Exception("Cannot reach config device.");
    }

    return base64.encode(response.bodyBytes);
  }

  Future<String> _analyzePicture(String picture) async {
    final response =
        await client.post(cvServerUri, body: picture).timeout(timeoutCvServer);

    if (response.statusCode != NetworkDeviceService.successCode) {
      throw Exception("Cannot reach cv server.");
    }

    return response.body;
  }

  Future<RemoteConfiguration> automaticConfig(ConfigDevice configDevice) async {
    final config = await _requestPicture(configDevice)
        .then((picture) => _analyzePicture(picture));

    return RemoteConfiguration.fromSerialized(config);
  }
}
