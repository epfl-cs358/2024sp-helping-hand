import "package:flutter/material.dart";
import "package:helping_hand/view/components/async/error_dialog.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class CircularValue<T> extends StatelessWidget {
  static const debugErrorTag = "DEBUG";

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;

  const CircularValue({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (data) => builder(context, data),
      error: (error, stackTrace) {
        final errorText = error.toString();

        if (errorText.startsWith(debugErrorTag)) {
          return Text(errorText);
        }

        final dialog = ErrorDialog(error: errorText);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showDialog(context: context, builder: dialog.build);
        });

        return const SizedBox.shrink();
      },
    );
  }
}
