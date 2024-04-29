import "package:flutter/material.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/view/components/loading_indicator.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ConfigDeviceDiscovery extends HookConsumerWidget {
  const ConfigDeviceDiscovery({
    super.key,
    required this.step,
  });

  final ValueNotifier<int> step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discovery = ref.watch(discoveryServiceProvider);

    final skip = TextButton(
      onPressed: () => step.value = 2,
      child: const Text("Skip"),
    );
    final use = TextButton(
      onPressed: () => step.value = 1,
      child: const Text("Use Device"),
    );

    return FutureBuilder(
      future: discovery.getLocalConfigDevice(),
      builder: (context, snapshot) {
        final actions = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            skip,
            if (snapshot.hasData) use,
          ],
        );

        if (snapshot.hasData || snapshot.hasError) {
          return Column(
            children: [
              if (snapshot.hasData)
                const Text("Camera configuration device found."),
              if (snapshot.hasError) const Text("No config device found..."),
              actions,
            ],
          );
        }

        return Column(
          children: [
            const Text("Looking for a camera device..."),
            const LoadingIndicator(),
            actions,
          ],
        );
      },
    );
  }
}
