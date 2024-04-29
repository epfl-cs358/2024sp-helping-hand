import "package:flutter/material.dart";
import "package:helping_hand/model/configuration.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/view/components/configured_remote_device.dart";
import "package:helping_hand/view/components/loading_indicator.dart";
import "package:helping_hand/view/components/unconfigured_remote_device.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

const fakeConfiguredDevice = ConfiguredRemoteDevice(
  config: RemoteConfiguration(
      name: "My Configured Device", csvConfig: "", macAddress: ""),
  device: RemoteDevice(
    network:
        ActiveLanDevice(lan: NetworkDevice(subnet: 1, id: 1), macAddress: ""),
  ),
);

class OverviewPage extends HookConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discovery = ref.watch(discoveryServiceProvider);

    final appBar = AppBar(
      title: const Text("Helping Hand"),
      backgroundColor: Colors.blue,
    );

    final remotes = FutureBuilder(
      future: discovery.getLocalRemoteDevices(),
      builder: (context, snapshot) {
        final isEmpty = snapshot.hasData && snapshot.data!.isEmpty;

        if (snapshot.hasData && !isEmpty) {
          return Column(
            children: [
              const Text("Configured devices:"),
              fakeConfiguredDevice,
              const Text("Unconfigured devices:"),
              for (final (i, device) in snapshot.data!.indexed)
                UnconfiguredRemoteDevice(
                  device: device,
                  index: i,
                ),
            ],
          );
        }
        if (snapshot.hasData || isEmpty) {
          return const Text("No remote device found...");
        }

        return const Column(
          children: [
            Text("Looking for devices on network..."),
            LoadingIndicator(),
          ],
        );
      },
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: remotes,
      ),
    );
  }
}
