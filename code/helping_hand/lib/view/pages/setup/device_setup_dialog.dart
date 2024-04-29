import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/view/pages/setup/steps/add_device.dart";
import "package:helping_hand/view/pages/setup/steps/automatic_camera_setup.dart";
import "package:helping_hand/view/pages/setup/steps/config_device_discovery.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class DeviceSetupDialog extends HookConsumerWidget {
  static const _width = 400.0;

  final RemoteDevice device;

  const DeviceSetupDialog({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(0);
    final config = useState("");

    return SingleChildScrollView(
      child: SizedBox(
        width: _width,
        child: Stepper(
          currentStep: step.value,
          controlsBuilder: (context, details) => const Row(),
          steps: [
            Step(
              title: const Text("Select Configuration Camera"),
              content: ConfigDeviceDiscovery(step: step),
            ),
            Step(
              title: const Text("Automatic Setup"),
              content: AutomaticCameraSetup(
                step: step,
                config: config,
              ),
            ),
            Step(
              title: const Text("Add Device"),
              content: AddDevice(
                device: device,
                config: config.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
