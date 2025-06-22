import 'package:flutter/material.dart';

class SelectableButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SelectableButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text),
      ),
    );
  }
}
