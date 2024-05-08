import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/service/remote_controller_service.dart";
import "package:helping_hand/utils/types.dart";
import "package:helping_hand/view/components/card_button.dart";
import "package:helping_hand/view/components/grid_menu_content.dart";
import "package:helping_hand/view/pages/remote/button_setup/button_setup_dialog.dart";
import "package:helping_hand/view/pages/remote/components/remote_button.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class RemoteButtonsList extends HookConsumerWidget {
  final SavedRemote remote;

  const RemoteButtonsList({
    super.key,
    required this.remote,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteController = ref.watch(
      RemoteControllerService.povider(remote.device),
    );
    final requestState = useState(RequestState.still);

    final addButton = CardButton(
      label: ButtonSetupDialog.title,
      icon: Icons.add,
      color: CardButton.helperColor,
      onTap: () => showDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
          child: ButtonSetupDialog(remote: remote),
        ),
      ),
    );

    final content = [
      for (final button in remote.config.buttons)
        RemoteButton(
          button: button,
          requestState: requestState,
          onPress: () => remoteController.shortPressButton(button),
          onLongPress: () => remoteController.longPressButton(button),
        ),
      addButton,
    ];

    return GridMenuContent(children: content);
  }
}
