import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';

class RepeatSettingWidget extends StatelessWidget {
  final bool isRepeating;
  final Function(bool?) onChanged;
  final VoidCallback? onIntervalTap;
  final String intervalText;

  const RepeatSettingWidget({
    super.key,
    required this.isRepeating,
    required this.onChanged,
    this.onIntervalTap,
    required this.intervalText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isRepeating,
          onChanged: onChanged,
          activeColor: mainColor,
        ),
        const Text('반복 활성화'),
        const Spacer(),
        if (isRepeating && onIntervalTap != null)
          InkWell(
            onTap: onIntervalTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: mainColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$intervalText마다',
                style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
