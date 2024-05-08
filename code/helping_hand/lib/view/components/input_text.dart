import "package:flutter/material.dart";

class InputText extends StatelessWidget {
  static const maxWidth = 250.0;

  const InputText({
    super.key,
    this.controller,
    this.label,
    this.errorText,
    this.onChanged,
    this.autofocus = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? label;
  final String? errorText;
  final void Function(String value)? onChanged;
  final bool autofocus;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    final textField = TextField(
      controller: controller,
      decoration: InputDecoration(
        label: label == null ? null : Text(label),
        errorText: errorText,
      ),
      onChanged: onChanged,
      autofocus: autofocus,
      maxLines: maxLines,
    );

    return Container(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      child: textField,
    );
  }
}
