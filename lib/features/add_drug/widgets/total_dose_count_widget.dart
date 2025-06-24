import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';

class TotalDoseCountWidget extends StatelessWidget {
  final bool hasTotalDoseCount;
  final TextEditingController controller;
  final Function(bool?) onChanged;

  const TotalDoseCountWidget({
    super.key,
    required this.hasTotalDoseCount,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: hasTotalDoseCount,
          onChanged: onChanged,
          activeColor: mainColor,
        ),
        const Text('총 복용횟수 설정'),
        const SizedBox(width: 16),
        if (hasTotalDoseCount)
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '총 복용횟수',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
