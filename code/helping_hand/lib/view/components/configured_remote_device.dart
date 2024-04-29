import "package:flutter/material.dart";
import "package:helping_hand/model/configuration.dart";
import "package:helping_hand/model/device.dart";

class ConfiguredRemoteDevice extends StatelessWidget {
  final RemoteConfiguration config;
  final RemoteDevice device;

  const ConfiguredRemoteDevice({
    super.key,
    required this.config,
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(config.name),
      ),
    );
  }
}
