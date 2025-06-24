import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';

class WeekdaySelectorWidget extends StatelessWidget {
  final List<String> weekdays;
  final Set<String> selectedWeekdays;
  final Function(String, bool) onWeekdayToggle;

  const WeekdaySelectorWidget({
    super.key,
    required this.weekdays,
    required this.selectedWeekdays,
    required this.onWeekdayToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          weekdays.map((weekday) {
            final isSelected = selectedWeekdays.contains(weekday);
            Color textColor;
            if (weekday == '토') {
              textColor = Colors.blue;
            } else if (weekday == '일') {
              textColor = Colors.red;
            } else {
              textColor = Colors.black;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: FilterChip(
                  label: Text(
                    weekday,
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                  selected: isSelected,
                  onSelected: (selected) => onWeekdayToggle(weekday, selected),
                  backgroundColor: Colors.grey[200],
                  selectedColor: mainColor.withOpacity(0.3),
                  checkmarkColor: mainColor,
                ),
              ),
            );
          }).toList(),
    );
  }
}
