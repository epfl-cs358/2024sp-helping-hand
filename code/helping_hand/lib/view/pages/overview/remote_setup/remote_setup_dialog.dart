import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/device.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/components/change_string_dialog.dart";
import "package:helping_hand/view/components/input_text.dart";
import "package:helping_hand/view/components/scroll_body.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";
import "package:helping_hand/view/pages/overview/remote_setup/steps/add_device.dart";
import "package:helping_hand/view/pages/overview/remote_setup/steps/automatic_configuration.dart";
import "package:helping_hand/view/pages/overview/remote_setup/steps/select_remote_device.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class RemoteSetupDialog extends HookConsumerWidget {
  static const _maxWidth = InputText.maxWidth + 150;

  const RemoteSetupDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(0);
    final remote = useState<RemoteDevice>(const RemoteDevice.none());
    final config = useState(const RemoteConfiguration.empty());

    importRemote(String remoteData) {
      try {
        final remote = SavedRemote.fromSerialized(remoteData);
        ref.read(SavedRemotesNotifier.provider.notifier).setRemote(remote);
        Navigator.pop(context);
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Import failed, wrong config format."),
          ),
        );
      }
    }

    final closeButton = IconButton(
      onPressed: Navigator.of(context).pop,
      icon: const Icon(Icons.close),
    );
    final importButton = IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => ChangeStringDialog(
          title: "Import Remote Data",
          defaultValue: "",
          multiline: true,
          onConfirm: importRemote,
        ),
      ),
      icon: const Icon(Icons.upload),
    );

    final appBar = AppBar(
      title: const Text("Add New Remote"),
      backgroundColor: OverviewPage.appBarColor,
      actions: [
        importButton,
        closeButton,
      ],
    );

    final remoteIpStep = Step(
      title: const Text("Select Remote Device"),
      content: SelectRemoteDevice(
        step: step,
        remote: remote,
      ),
    );
    final automaticConfigStep = Step(
      title: const Text("Automatic Configuration"),
      content: AutomaticConfiguration(
        step: step,
        config: config,
      ),
    );
    final deviceNameStep = Step(
      title: const Text("Add Device"),
      content: AddDevice(
        remote: remote.value,
        config: config.value,
      ),
    );

    final stepperForm = Stepper(
      currentStep: step.value,
      controlsBuilder: (context, details) => const Row(),
      steps: [
        remoteIpStep,
        automaticConfigStep,
        deviceNameStep,
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: ScrollBody(
        child: Container(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: stepperForm,
        ),
      ),
    );
  }
}
