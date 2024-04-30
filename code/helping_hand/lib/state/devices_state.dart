import "package:helping_hand/model/device.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

typedef DevicesData = List<RemoteDevice>;

class DevicesState extends AsyncNotifier<DevicesData> {
  DevicesState();

  @override
  Future<DevicesData> build() async {
    final discovery = ref.watch(discoveryServiceProvider);
    return await discovery.getLocalRemoteDevices();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final devicesProvider = AsyncNotifierProvider<DevicesState, DevicesData>(
  () => DevicesState(),
);
