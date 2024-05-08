import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/config/button.dart";
import "package:helping_hand/utils/types.dart";
import "package:helping_hand/view/components/async/loading_indicator.dart";
import "package:helping_hand/view/components/card_button.dart";

class RemoteButton extends HookWidget {
  static final _color = Colors.green[600];
  static const outcomeDuration = Duration(seconds: 1);

  final Button button;
  final FutureVoidCallback onPress;
  final FutureVoidCallback onLongPress;
  final ValueNotifier<RequestState> requestState;

  const RemoteButton({
    super.key,
    required this.button,
    required this.requestState,
    required this.onPress,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrent = useState(false);

    Future<void> loadingPerform(FutureVoidCallback action) async {
      requestState.value = RequestState.pending;
      isCurrent.value = true;

      try {
        await action();
        if (context.mounted) {
          requestState.value = RequestState.valid;
        }
      } catch (e) {
        if (context.mounted) {
          requestState.value = RequestState.invalid;
        }
      }

      await Future.delayed(outcomeDuration);
      if (context.mounted) {
        requestState.value = RequestState.still;
        isCurrent.value = false;
      }
    }

    final stillChildren = [
      Text(
        button.label,
        style: const TextStyle(fontSize: CardButton.textSize),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: CardButton.textIconSpacing),
      const Icon(
        Icons.ads_click,
        size: CardButton.iconSize,
      ),
    ];

    final content = [
      if (requestState.value == RequestState.pending && isCurrent.value)
        const LoadingIndicator(
          color: Colors.white,
        )
      else if (requestState.value == RequestState.still || !isCurrent.value)
        ...stillChildren
      else
        Icon(
          requestState.value == RequestState.valid
              ? Icons.check_circle_outline
              : Icons.error_outline,
          size: LoadingIndicator.defaultSide,
        ),
    ];

    return Card.outlined(
      color: _color,
      child: InkWell(
        onTap: requestState.value != RequestState.still
            ? null
            : () => loadingPerform(onPress),
        onLongPress: requestState.value != RequestState.still
            ? null
            : () => loadingPerform(onLongPress),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: content,
          ),
        ),
      ),
    );
  }
}
