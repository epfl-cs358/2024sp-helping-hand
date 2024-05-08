import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/utils/types.dart";
import "package:helping_hand/view/components/async/loading_indicator.dart";
import "package:helping_hand/view/components/buttons/button_primary.dart";
import "package:helping_hand/view/components/buttons/button_secondary.dart";
import "package:helping_hand/view/components/input_text.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";
import "package:helping_hand/view/pages/overview/remote_setup/steps/select_remote_device.dart";
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
    final ipController =
        useTextEditingController(text: SelectRemoteDevice.defaultIp);
    final confirmState = useState(SimpleRequestState.still);

    const subtitle = Text(
      "Select the camera IP address:",
      style: TextStyle(fontSize: ButtonPrimary.textSize),
    );

    final ipAddressField = InputText(
      controller: ipController,
      errorText: error.value,
      label: "Config IP",
      onChanged: (_) {
        error.value = null;
      },
    );

    final skipButton = ButtonSecondary(
      onPressed: () => step.value++,
      label: "Skip",
    );
    final confirmButton = ButtonPrimary(
      onPressed: () async {
        confirmState.value = SimpleRequestState.pending;
        try {
          final configDevice =
              await networkService.configWithIp(ipController.text);
          // TODO perform automatic configuration
          confirmState.value = SimpleRequestState.valid;
          step.value++;
        } catch (_) {
          error.value = "Camera device not reachable.";
          confirmState.value = SimpleRequestState.still;
        }
      },
      label: "Confirm",
    );

    final actions = Padding(
      padding: const EdgeInsets.all(8.0),
      child: switch (confirmState.value) {
        SimpleRequestState.still => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              skipButton,
              const SizedBox(width: 10),
              confirmButton,
            ],
          ),
        SimpleRequestState.pending => const LoadingIndicator(
            side: 28,
            color: OverviewPage.appBarColor,
          ),
        SimpleRequestState.valid => const SizedBox.shrink(),
      },
    );

    return Column(
      children: [
        subtitle,
        ipAddressField,
        actions,
      ],
    );
  }
}
