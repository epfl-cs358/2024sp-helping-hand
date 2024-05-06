import "package:flutter/material.dart";
import "package:helping_hand/model/saved_remote.dart";
import "package:helping_hand/view/components/card_button.dart";

class SavedRemoteDevice extends StatelessWidget {
  static final _color = Colors.teal[600];

  final SavedRemote remote;
  final VoidCallback onPress;
  final VoidCallback onLongPress;

  const SavedRemoteDevice({
    super.key,
    required this.remote,
    required this.onPress,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: _color,
      child: InkWell(
        onTap: onPress,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                remote.name,
                style: const TextStyle(fontSize: CardButton.textSize),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CardButton.textIconSpacing),
              Icon(
                remote.isOnline ? Icons.cloud_done : Icons.cloud_off,
                size: CardButton.iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
