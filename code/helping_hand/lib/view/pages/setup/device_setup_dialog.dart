import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/view/pages/setup/steps/add_device.dart";
import "package:helping_hand/view/pages/setup/steps/automatic_configuration.dart";
import "package:helping_hand/view/pages/setup/steps/select_remote_device.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class DeviceSetupDialog extends HookConsumerWidget {
  const DeviceSetupDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(0);
    final remote = useState<RemoteDevice>(const RemoteDevice.none());
    final config = useState(const RemoteConfiguration.empty());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Remote"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Stepper(
        currentStep: step.value,
        controlsBuilder: (context, details) => const Row(),
        steps: [
          Step(
            title: const Text("Select Remote Device"),
            content: SelectRemoteDevice(
              step: step,
              remote: remote,
            ),
          ),
          Step(
            title: const Text("Automatic Configuration"),
            content: AutomaticConfiguration(
              step: step,
              config: config,
            ),
          ),
          Step(
            title: const Text("Add Device"),
            content: AddDevice(
              remote: remote.value,
              config: config.value,
            ),
          ),
        ],
      ),
    );
  }
}
