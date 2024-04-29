import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/view/components/loading_indicator.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class AutomaticCameraSetup extends HookConsumerWidget {
  static const _lineSeparator = "\n";

  const AutomaticCameraSetup({
    super.key,
    required this.step,
    required this.config,
  });

  final ValueNotifier<int> step;
  final ValueNotifier<String> config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupStarted = useState(false);

    if (!setupStarted.value) {
      return Column(
        children: [
          const Text("Position the camera correctly."),
          TextButton(
            onPressed: () {
              setupStarted.value = true;
            },
            child: const Text("Start Setup"),
          )
        ],
      );
    }

    return FutureBuilder(
      future: Future.delayed(
        const Duration(seconds: 1),
        // TODO vision server service
        () => "1\n2\n3",
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final response = snapshot.data!;
          final buttonsCount = response.split(_lineSeparator).length;

          return Column(
            children: [
              Text(
                  "Automatic setup successful!\n$buttonsCount button(s) found."),
              TextButton(
                onPressed: () {
                  config.value = response;
                  step.value++;
                },
                child: const Text("Next"),
              )
            ],
          );
        }

        if (snapshot.hasError) {
          return const Text("Setup failed. Please restart.");
        }

        return const Column(
          children: [
            Text("Automatic setup..."),
            LoadingIndicator(),
          ],
        );
      },
    );
  }
}
