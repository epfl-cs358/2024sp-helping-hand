import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/utils/types.dart";
import "package:helping_hand/view/components/async/loading_indicator.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ActionButton extends HookConsumerWidget {
  static const color = Colors.indigo;

  final ValueNotifier<bool> isLoading;
  final FutureVoidCallback onTap;
  final Widget child;

  const ActionButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // avoid loading on every action button (only show loading on pressed button)
    final isCurrent = useState(false);

    final loadingOrChild = isLoading.value && isCurrent.value
        ? const LoadingIndicator(
            side: 24,
          )
        : child;

    onCardTap() async {
      isLoading.value = true;
      isCurrent.value = true;
      try {
        await onTap();
      } catch (_) {
        // ignore errors
      }
      isCurrent.value = false;
      isLoading.value = false;
    }

    final card = SizedBox(
      width: 50,
      height: 50,
      child: Card.outlined(
        color: color,
        child: InkWell(
          onTap: isLoading.value ? null : onCardTap,
          child: Center(
            child: loadingOrChild,
          ),
        ),
      ),
    );

    return card;
  }
}
