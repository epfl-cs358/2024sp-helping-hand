import "package:helping_hand/model/config/button.dart";
import "package:helping_hand/model/config/point_2d.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/state/http_client.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:http/http.dart" as http;

class RemoteControllerService {
  static const shortPressEndoint = "short-press";
  static const longPressEndoint = "long-press";
  static const moveOutEndpoint = "move-out";
  static const moveEndpoint = "go-to";

  static const successCode = NetworkDeviceService.successCode;
  static const timeoutDuration = Duration(seconds: 3);

  static final povider = Provider.family<RemoteControllerService, RemoteDevice>(
    (ref, device) => RemoteControllerService._(
      client: ref.watch(httpClientProvider),
      device: device,
    ),
  );

  RemoteControllerService._({
    required this.client,
    required this.device,
  });

  final http.Client client;
  final RemoteDevice device;

  Future<void> _wrapUnavailable(Future<http.Response> request) =>
      request.then((value) {
        if (value.statusCode != successCode) {
          throw Exception("Device is not available.");
        }
      });

  Future<void> _callEndpoint(String endpoint) => _wrapUnavailable(
        client.get(
          Uri.http(
            device.network.ipAddress,
            endpoint,
          ),
        ),
      );

  Future<void> shortPress() => _callEndpoint(shortPressEndoint);
  Future<void> longPress() => _callEndpoint(longPressEndoint);
  Future<void> moveOut() => _callEndpoint(moveOutEndpoint);

  Future<void> moveTo(Point2D pos) => _wrapUnavailable(
        client
            .get(
              Uri.http(
                device.network.ipAddress,
                moveEndpoint,
                pos.queryParams(),
              ),
            )
            .timeout(timeoutDuration),
      );

  Future<void> shortPressButton(Button button) async {
    await moveTo(button.pos);
    await shortPress();
    await moveOut();
  }

  Future<void> longPressButton(Button button) async {
    await moveTo(button.pos);
    await longPress();
    await moveOut();
  }
}
