import "package:helping_hand/model/data/remote_data.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/state/shared_preferences.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

class DatabaseService {
  static const remotesMacAddressesCollection = "remotes_mac_addresses";

  final SharedPreferences sharedPreferences;

  static final povider = FutureProvider<DatabaseService>(
    (ref) async {
      final sharedPreferences =
          await ref.watch(sharedPreferencesProvider.future);

      final remotesCollection =
          sharedPreferences.getStringList(remotesMacAddressesCollection);
      if (remotesCollection == null) {
        await sharedPreferences.setStringList(
          remotesMacAddressesCollection,
          [],
        );
      }

      return DatabaseService._(
        sharedPreferences: sharedPreferences,
      );
    },
  );

  DatabaseService._({required this.sharedPreferences});

  List<MacAddress> getAllMacAddresses() =>
      sharedPreferences.getStringList(remotesMacAddressesCollection)!;

  RemoteData getRemoteFromMac(MacAddress mac) {
    final name =
        sharedPreferences.getString(mac + RemoteData.nameCollectionSuffix)!;
    final config =
        sharedPreferences.getString(mac + RemoteData.configCollectionSuffix)!;
    final ipAddress = sharedPreferences
        .getString(mac + RemoteData.ipAddressCollectionSuffix)!;

    return RemoteData(
      name: name,
      config: config,
      ipAddress: ipAddress,
    );
  }

  Future<void> setRemoteData(SavedRemote remote) async {
    final mac = remote.device.network.macAddress;
    final data = remote.data();

    final nameSet = sharedPreferences.setString(
      mac + RemoteData.nameCollectionSuffix,
      data.name,
    );
    final configSet = sharedPreferences.setString(
      mac + RemoteData.configCollectionSuffix,
      data.config,
    );
    final ipAddressSet = sharedPreferences.setString(
      mac + RemoteData.ipAddressCollectionSuffix,
      data.ipAddress,
    );

    await Future.wait([nameSet, configSet, ipAddressSet]);

    final remotes = getAllMacAddresses();
    if (!remotes.contains(mac)) {
      remotes.add(mac);
      await sharedPreferences.setStringList(
        remotesMacAddressesCollection,
        remotes,
      );
    }
  }

  Future<void> removeRemote(MacAddress mac) async {
    final nameDel =
        sharedPreferences.remove(mac + RemoteData.nameCollectionSuffix);
    final configDel =
        sharedPreferences.remove(mac + RemoteData.configCollectionSuffix);
    final ipAddressDel =
        sharedPreferences.remove(mac + RemoteData.ipAddressCollectionSuffix);

    await Future.wait([nameDel, configDel, ipAddressDel]);

    final remotes = getAllMacAddresses();
    remotes.remove(mac);
    await sharedPreferences.setStringList(
      remotesMacAddressesCollection,
      remotes,
    );
  }
}
