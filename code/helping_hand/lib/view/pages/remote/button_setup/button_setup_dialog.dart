import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/button.dart";
import "package:helping_hand/model/config/point_2d.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/service/remote_controller_service.dart";
import "package:helping_hand/service/remote_coordinates_service.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/components/async/circular_value.dart";
import "package:helping_hand/view/components/buttons/button_primary.dart";
import "package:helping_hand/view/components/buttons/button_secondary.dart";
import "package:helping_hand/view/components/card_button.dart";
import "package:helping_hand/view/components/input_text.dart";
import "package:helping_hand/view/components/scroll_body.dart";
import "package:helping_hand/view/pages/overview/overview_page.dart";
import "package:helping_hand/view/pages/remote/button_setup/action_button.dart";
import "package:helping_hand/view/pages/remote/button_setup/grid_action_content.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ButtonSetupDialog extends HookConsumerWidget {
  static const title = "New Button";
  static const textFieldConstraints = BoxConstraints(maxWidth: 200);

  // FIXME Parameters to tweak
  static const _scales = [80.0, 20.0, 5.0];

  static const directions = [
    Point2D(x: -1, y: 0),
    Point2D(x: 0, y: -1),
    Point2D(x: 0, y: 1),
    Point2D(x: 1, y: 0),
  ];
  static final _deltas =
      _scales.expand((s) => directions.map((d) => d.scale(s)));
  static const _turns = [2, 1, 3, 0];
  static const _speeds = [
    Icons.fast_forward,
    Icons.arrow_forward,
    Icons.chevron_right,
  ];

  final SavedRemote remote;

  const ButtonSetupDialog({
    super.key,
    required this.remote,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteCooordinates = ref.watch(RemoteCoordinatesService.povider);
    final remoteController =
        ref.watch(RemoteControllerService.povider(remote.device));

    final buttonLabelController = useTextEditingController();
    final requestPending = useState(true);
    final isInitialRequest = useState(true);
    final buttonPos = useState(RemoteCoordinatesService.remoteAreaCenter);

    // Move remote head in and out
    useEffect(
      () {
        remoteController.moveTo(buttonPos.value).then((_) {
          if (context.mounted) {
            requestPending.value = false;
            isInitialRequest.value = false;
          }
        });
        return () => remoteController.moveOut();
      },
      const [],
    );

    final appBar = AppBar(
      title: const Text(title),
      backgroundColor: OverviewPage.appBarColor,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      ],
    );

    Future<void> onDeltaRequest(Point2D delta) {
      final resultPos = remoteCooordinates.constrainRemoteArea(
        buttonPos.value.add(delta: delta),
      );

      return remoteController
          .moveTo(resultPos)
          .then((_) => buttonPos.value = resultPos);
    }

    final buttonLabelField = InputText(
      controller: buttonLabelController,
      label: "Button Name",
      autofocus: true,
    );

    final posDisplayed = buttonPos.value.sub(
      delta: RemoteCoordinatesService.remoteAreaOrigin,
    );
    final coords = Text(
      "X: ${posDisplayed.x}  Y: ${posDisplayed.y}",
      style: const TextStyle(
        color: Colors.white,
        fontSize: CardButton.textSize,
      ),
    );

    final grid = GridActionContent(
      children: [
        for (final (i, delta) in _deltas.indexed)
          ActionButton(
            isLoading: requestPending,
            onTap: () => onDeltaRequest(delta),
            child: RotatedBox(
              quarterTurns: _turns[i % directions.length],
              child: Icon(
                _speeds[i ~/ directions.length],
                size: 26,
              ),
            ),
          ),
      ],
    );

    final testPressButton = ButtonSecondary(
      onPressed: () async {
        requestPending.value = true;
        await remoteController.shortPress();
        if (context.mounted) {
          requestPending.value = false;
        }
      },
      label: "Test Press",
    );

    final registerButton = ButtonPrimary(
      onPressed: () {
        ref.read(SavedRemotesNotifier.provider.notifier).setRemote(
              remote.withArgs(
                config: remote.config.withNewButton(
                  Button(
                    label: buttonLabelController.text,
                    pos: buttonPos.value,
                  ),
                ),
              ),
            );
        Navigator.pop(context);
      },
      label: "Register Button",
    );

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buttonLabelField,
        const SizedBox(height: 18),
        coords,
        grid,
        const SizedBox(height: 10),
        testPressButton,
        const SizedBox(height: 20),
        registerButton,
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: ScrollBody(
        child: requestPending.value && isInitialRequest.value
            ? CircularValue.loadingIndicator
            : content,
      ),
    );
  }
}
