import "package:flutter/material.dart";
import "package:helping_hand/model/network.dart";
import "package:helping_hand/state/saved_remote.dart";
import "package:helping_hand/view/components/async/circular_value.dart";
import "package:helping_hand/view/pages/remote/components/remote_app_bar.dart";
import "package:helping_hand/view/pages/remote/components/remote_buttons_list.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class RemotePage extends HookConsumerWidget {
  final MacAddress mac;

  const RemotePage({
    super.key,
    required this.mac,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remote = ref.watch(SavedRemoteNotifier.provider(mac));
    final remoteValue = remote.valueOrNull;

    final appBar =
        remoteValue == null ? null : RemoteAppBar(remote: remoteValue);

    final buttons = CircularValue(
      value: remote,
      builder: (context, value) => RemoteButtonsList(remote: value),
    );

    return Scaffold(
      appBar: appBar?.build(context, ref),
      body: buttons,
    );
  }
}
