import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/service/network_discovery_service.dart";
import "package:helping_hand/utils/types.dart";
import "package:helping_hand/view/components/async/loading_indicator.dart";
import "package:helping_hand/view/components/buttons/button_primary.dart";
import "package:helping_hand/view/components/input_text.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SelectRemoteDevice extends HookConsumerWidget {
  static const defaultIp = "192.168.";

  const SelectRemoteDevice({
    super.key,
    required this.step,
    required this.remote,
  });

  final ValueNotifier<int> step;
  final ValueNotifier<RemoteDevice?> remote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkService = ref.watch(NetworkDeviceService.povider);
    final error = useState<String?>(null);
    final ipController = useTextEditingController(text: defaultIp);
    final confirmState = useState(SimpleRequestState.still);

    const subtitle = Text(
      "Select the remote IP address:",
      style: TextStyle(fontSize: ButtonPrimary.textSize),
    );

    final ipField = InputText(
      controller: ipController,
      errorText: error.value,
      label: "Remote IP",
      onChanged: (_) {
        error.value = null;
      },
      autofocus: true,
    );

    final actions = Padding(
      padding: const EdgeInsets.only(top: 10),
      child: switch (confirmState.value) {
        SimpleRequestState.still => ButtonPrimary(
            onPressed: () async {
              confirmState.value = SimpleRequestState.pending;
              try {
                remote.value =
                    await networkService.remoteWithIp(ipController.text);
                confirmState.value = SimpleRequestState.valid;
                step.value++;
              } catch (_) {
                error.value = "Remote device not reachable.";
                confirmState.value = SimpleRequestState.still;
              }
            },
            label: "Confirm",
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
        ipField,
        actions,
      ],
    );
  }
}
