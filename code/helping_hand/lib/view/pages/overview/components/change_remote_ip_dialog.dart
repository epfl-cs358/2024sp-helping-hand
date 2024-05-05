import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:helping_hand/model/network.dart";

class ChangeRemoteIpDialog extends HookWidget {
  final IpAddress defaultIp;
  final void Function(IpAddress newIp) onNewIp;

  const ChangeRemoteIpDialog({
    super.key,
    required this.defaultIp,
    required this.onNewIp,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: defaultIp);

    return AlertDialog(
      title: const Text("Change Ip Address"),
      content: TextField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () {
            onNewIp(controller.text);
            Navigator.pop(context);
          },
          child: const Text("Confirm"),
        )
      ],
    );
  }
}
