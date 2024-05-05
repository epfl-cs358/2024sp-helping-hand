import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/utils/types.dart";
import "package:helping_hand/view/components/async/loading_indicator.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class AutomaticConfiguration extends HookConsumerWidget {
  const AutomaticConfiguration({
    super.key,
    required this.step,
    required this.config,
  });

  final ValueNotifier<int> step;
  final ValueNotifier<RemoteConfiguration> config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkService = ref.watch(NetworkDeviceService.povider);
    final error = useState<String?>(null);
    final ipController = useTextEditingController(text: "192.168.");
    final confirmState = useState(ConfirmState.invalid);

    return Column(
      children: [
        const Text("Select the camera IP address:"),
        TextField(
          controller: ipController,
          decoration: InputDecoration(
            errorText: error.value,
            label: const Text("Config IP"),
          ),
          onChanged: (_) {
            error.value = null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            switch (confirmState.value) {
              ConfirmState.invalid => Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        step.value++;
                      },
                      child: const Text("Skip"),
                    ),
                    TextButton(
                      onPressed: () async {
                        confirmState.value = ConfirmState.pending;
                        try {
                          final configDevice = await networkService
                              .configWithIp(ipController.text);
                          // TODO perform automatic configuration
                          confirmState.value = ConfirmState.valid;
                          step.value++;
                        } catch (_) {
                          error.value = "Camera device not reachable.";
                          confirmState.value = ConfirmState.invalid;
                        }
                      },
                      child: const Text("Confirm"),
                    ),
                  ],
                ),
              ConfirmState.pending => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LoadingIndicator(
                    side: 28,
                  ),
                ),
              ConfirmState.valid => const SizedBox.shrink(),
            }
          ],
        )
      ],
    );
  }
}
