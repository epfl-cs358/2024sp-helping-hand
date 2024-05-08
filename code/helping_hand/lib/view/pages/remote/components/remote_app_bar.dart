import "package:flutter/material.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/state/saved_remote.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";
import "package:helping_hand/view/pages/remote/components/delete_remote_dialog.dart";
import "package:helping_hand/view/pages/remote/edit_config/edit_remote_config_dialog.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class RemoteAppBar extends HookConsumerWidget {
  final SavedRemote remote;

  const RemoteAppBar({
    super.key,
    required this.remote,
  });

  @override
  AppBar build(BuildContext context, WidgetRef ref) {
    final editDialog = Dialog.fullscreen(
      child: EditRemoteConfigDialog(
        remote: remote,
        onNewConfig: (newConfig) {
          ref.read(SavedRemotesNotifier.provider.notifier).setRemote(
                remote.withArgs(config: newConfig),
              );
        },
      ),
    );
    final editButton = IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => editDialog,
      ),
      icon: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );

    final deleteDialog = DeleteRemoteDialog(
      onConfirm: () {
        ref
            .read(
              SavedRemoteNotifier.provider(
                remote.device.network.macAddress,
              ).notifier,
            )
            .delete();
        Navigator.pop(context);
      },
    );
    final deleteButton = IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => deleteDialog,
      ),
      icon: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );

    return AppBar(
      title: Text(remote.name),
      backgroundColor: OverviewPage.appBarColor,
      actions: [
        deleteButton,
        editButton,
      ],
    );
  }
}
