import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/service/database_service.dart";
import "package:helping_hand/state/saved_remote.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SavedRemotesNotifier extends AsyncNotifier<List<SavedRemote>> {
  static final provider =
      AsyncNotifierProvider<SavedRemotesNotifier, List<SavedRemote>>(
          SavedRemotesNotifier.new);

  @override
  Future<List<SavedRemote>> build() async {
    final db = await ref.watch(DatabaseService.povider.future);
    final remotesMacAddresses = db.getAllMacAddresses();

    return Future.wait(
      remotesMacAddresses.map(
        (mac) => ref.watch(
          SavedRemoteNotifier.provider(mac).future,
        ),
      ),
    );
  }

  void refresh() {
    state.maybeWhen(
      data: (data) {
        for (final remote in data) {
          ref.invalidate(
            SavedRemoteNotifier.provider(
              remote.device.network.macAddress,
            ),
          );
        }
      },
      orElse: () {},
    );
  }

  Future<void> setRemote(SavedRemote remote) async {
    state = const AsyncValue.loading();
    final db = await ref.watch(DatabaseService.povider.future);
    await db.setRemoteData(remote);

    ref.invalidate(
      SavedRemoteNotifier.provider(
        remote.device.network.macAddress,
      ),
    );
    ref.invalidateSelf();
  }
}
