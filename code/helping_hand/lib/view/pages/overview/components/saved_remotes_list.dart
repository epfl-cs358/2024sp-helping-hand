import "package:flutter/material.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/pages/overview/components/change_remote_ip_dialog.dart";
import "package:helping_hand/view/pages/overview/components/saved_remote_device.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SavedRemotesList extends HookConsumerWidget {
  final List<SavedRemote> remotes;

  const SavedRemotesList({
    super.key,
    required this.remotes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (remotes.isEmpty) {
      return const Text("No saved remote.");
    }

    return Column(
      children: [
        const Text("Saved remotes:"),
        for (final remote in remotes)
          SavedRemoteDevice(
            remote: remote,
            onClick: () {
              if (!remote.isOnline) {
                final changeIpDialog = ChangeRemoteIpDialog(
                  defaultIp: remote.device.network.ipAddress,
                  onNewIp: (newIp) => ref
                      .read(SavedRemotesNotifier.provider.notifier)
                      .setRemote(
                        remote.withArgs(
                          network:
                              remote.device.network.withArgs(ipAddress: newIp),
                        ),
                      ),
                );

                showDialog(
                  context: context,
                  builder: (context) => changeIpDialog,
                );
              }
            },
          ),
      ],
    );
  }
}
