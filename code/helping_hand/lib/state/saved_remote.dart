import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/service/database_service.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SavedRemoteNotifier extends FamilyAsyncNotifier<SavedRemote, MacAddress> {
  static final provider = AsyncNotifierProvider.family<SavedRemoteNotifier,
      SavedRemote, MacAddress>(SavedRemoteNotifier.new);

  @override
  Future<SavedRemote> build(MacAddress arg) async {
    final db = await ref.watch(DatabaseService.povider.future);
    final network = ref.watch(NetworkDeviceService.povider);

    final data = db.getRemoteFromMac(arg);

    final remote = RemoteDevice(
      network: NetworkDevice(
        ipAddress: data.ipAddress,
        macAddress: arg,
      ),
    );
    final isOnline = await network.remoteIsOnline(remote);

    return SavedRemote(
      name: data.name,
      config: RemoteConfiguration(csvConfig: data.config),
      device: remote,
      isOnline: isOnline,
    );
  }

  Future<void> delete() async {
    final db = await ref.watch(DatabaseService.povider.future);
    await db.removeRemote(arg);
    ref.invalidate(SavedRemotesNotifier.provider);
  }
}
