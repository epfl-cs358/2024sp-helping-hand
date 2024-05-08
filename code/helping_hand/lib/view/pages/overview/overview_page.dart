import "package:flutter/material.dart";
import "package:helping_hand/state/saved_remotes.dart";
import "package:helping_hand/view/components/async/circular_value.dart";
import "package:helping_hand/view/pages/overview/components/saved_remotes_list.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class OverviewPage extends HookConsumerWidget {
  static const appBarColor = Colors.blue;

  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(SavedRemotesNotifier.provider);

    final appBar = AppBar(
      title: const Text("Helping Hand"),
      backgroundColor: appBarColor,
    );

    final remotes = CircularValue(
      value: devices,
      builder: (context, value) {
        value.sort();
        return SavedRemotesList(remotes: value);
      },
    );

    return Scaffold(
      appBar: appBar,
      body: remotes,
    );
  }
}
