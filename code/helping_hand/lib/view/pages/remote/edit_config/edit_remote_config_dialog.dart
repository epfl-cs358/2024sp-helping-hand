import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/button.dart";
import "package:helping_hand/model/config/configuration.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";
import "package:helping_hand/view/pages/remote/edit_config/reorderable_buttons_config.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class EditRemoteConfigDialog extends HookConsumerWidget {
  final SavedRemote remote;
  final void Function(RemoteConfiguration newConfig) onNewConfig;

  const EditRemoteConfigDialog({
    super.key,
    required this.remote,
    required this.onNewConfig,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newConfig = useState(remote.config);

    updateConfig(List<Button> buttons) =>
        newConfig.value = RemoteConfiguration.fromButtons(buttons);

    final confirmButton = IconButton(
      onPressed: () {
        onNewConfig(newConfig.value);
        Navigator.pop(context);
      },
      icon: const Icon(Icons.check),
    );
    final exportButton = IconButton(
      onPressed: () => Clipboard.setData(
        ClipboardData(
          text: remote.withArgs(config: newConfig.value).serialize(),
        ),
      ).then(
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Remote data copied to clipboard.")),
        ),
      ),
      icon: const Icon(Icons.copy),
    );

    final appBar = AppBar(
      title: const Text("Edit Remote Config"),
      backgroundColor: OverviewPage.appBarColor,
      leading: IconButton(
        onPressed: Navigator.of(context).pop,
        icon: const Icon(Icons.close),
      ),
      actions: [
        exportButton,
        confirmButton,
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: ReorderableButtonsCofig(
        buttons: newConfig.value.buttons,
        updateConfig: updateConfig,
      ),
    );
  }
}
