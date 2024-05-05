import "package:flutter/material.dart";
import "package:helping_hand/model/saved_remote.dart";

class SavedRemoteDevice extends StatelessWidget {
  final SavedRemote remote;
  final VoidCallback onClick;

  const SavedRemoteDevice({
    super.key,
    required this.remote,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(remote.name),
              Icon(remote.isOnline ? Icons.cloud_done : Icons.cloud_off),
            ],
          ),
        ),
      ),
    );
  }
}
