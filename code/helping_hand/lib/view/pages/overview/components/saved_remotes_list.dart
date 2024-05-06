import "package:flutter/material.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/state/saved_remote.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/components/card_button.dart";
import "package:helping_hand/view/components/change_string_dialog.dart";
import "package:helping_hand/view/components/grid_menu_content.dart";
import "package:helping_hand/view/navigation/routes.dart";
import "package:helping_hand/view/pages/overview/components/saved_remote_device.dart";
import "package:helping_hand/view/pages/overview/remote_setup/remote_setup_dialog.dart";
import "package:helping_hand/view/pages/remote/components/delete_remote_dialog.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SavedRemotesList extends HookConsumerWidget {
  final List<SavedRemote> remotes;

  const SavedRemotesList({
    super.key,
    required this.remotes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addRemote = CardButton(
      label: "Add Remote",
      icon: Icons.add,
      color: CardButton.helperColor,
      onTap: () => showDialog(
        context: context,
        builder: (context) => const Dialog.fullscreen(
          child: RemoteSetupDialog(),
        ),
      ),
    );

    final refresh = CardButton(
      onTap: ref.read(SavedRemotesNotifier.provider.notifier).refresh,
      icon: Icons.refresh,
      color: CardButton.helperColor,
      label: "Refresh",
    );

    remotePress(SavedRemote remote) {
      if (remote.isOnline) {
        Navigator.pushNamed(
          context,
          Routes.remote.name,
          arguments: remote.device.network.macAddress,
        );
      } else {
        final changeIpDialog = ChangeStringDialog(
          title: "Change IP Address",
          defaultValue: remote.device.network.ipAddress,
          onConfirm: (newIp) =>
              ref.read(SavedRemotesNotifier.provider.notifier).setRemote(
                    remote.withArgs(
                      network: remote.device.network.withArgs(ipAddress: newIp),
                    ),
                  ),
        );

        showDialog(
          context: context,
          builder: (context) => changeIpDialog,
        );
      }
    }

    remoteLongPress(SavedRemote remote) {
      final deleteRemoteDialog = DeleteRemoteDialog(
        onConfirm: () {
          ref
              .read(
                SavedRemoteNotifier.provider(
                  remote.device.network.macAddress,
                ).notifier,
              )
              .delete();
        },
      );
      final changeNameDialog = ChangeStringDialog(
        title: "Change Remote Name",
        defaultValue: remote.name,
        onConfirm: (newName) =>
            ref.read(SavedRemotesNotifier.provider.notifier).setRemote(
                  remote.withArgs(name: newName),
                ),
      );

      showDialog(
        context: context,
        builder: (context) =>
            remote.isOnline ? changeNameDialog : deleteRemoteDialog,
      );
    }

    final content = [
      for (final remote in remotes)
        SavedRemoteDevice(
          remote: remote,
          onPress: () => remotePress(remote),
          onLongPress: () => remoteLongPress(remote),
        ),
      addRemote,
      refresh,
    ];

    return GridMenuContent(children: content);
  }
}
