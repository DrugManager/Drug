import 'package:flutter/material.dart';

class TodayStatusWidget extends StatelessWidget {
  final bool canTake;
  final bool isTodayInRange;
  final bool hasTakenToday;

  const TodayStatusWidget({
    super.key,
    required this.canTake,
    required this.isTodayInRange,
    required this.hasTakenToday,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    if (hasTakenToday && isTodayInRange) {
      iconData = Icons.check_circle;
      iconColor = Colors.blue;
    } else if (canTake) {
      iconData = Icons.check_circle;
      iconColor = Colors.green;
    } else {
      iconData = Icons.info;
      iconColor = Colors.grey;
    }

    return Row(
      children: [
        Icon(iconData, color: iconColor),
        const SizedBox(width: 8),
        Text(
          '오늘 복용 상태',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                hasTakenToday && isTodayInRange
                    ? Colors.blue[700]
                    : canTake
                    ? Colors.green[700]
                    : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
