import "package:flutter/material.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/components/async/circular_value.dart";
import "package:helping_hand/view/pages/overview/components/saved_remotes_list.dart";
import "package:helping_hand/view/pages/setup/device_setup_dialog.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class OverviewPage extends HookConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(SavedRemotesNotifier.provider);

    final appBar = AppBar(
      title: const Text("Helping Hand"),
      backgroundColor: Colors.blue,
    );

    final refresh = OutlinedButton(
      onPressed: () =>
          ref.read(SavedRemotesNotifier.provider.notifier).refresh(),
      child: const Text("Refresh"),
    );

    final remotes = CircularValue(
      value: devices,
      builder: (context, value) => SavedRemotesList(remotes: value),
    );

    final addRemote = OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const Dialog.fullscreen(
            child: DeviceSetupDialog(),
          ),
        );
        // ref.read(SavedRemotesNotifier.provider.notifier).setRemote(
        //       const SavedRemote(
        //         name: "My new Remote",
        //         config: RemoteConfiguration.empty(),
        //         device: RemoteDevice(
        //           network: NetworkDevice(
        //             ipAddress: "192.168.1.31",
        //             macAddress: "0:1:32",
        //           ),
        //         ),
        //         isOnline: true,
        //       ),
        //     );
      },
      child: const Text("Add remote"),
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Column(
          children: [
            refresh,
            addRemote,
            remotes,
          ],
        ),
      ),
    );
  }
}
