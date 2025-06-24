import 'package:flutter/material.dart';

class UIUtils {
  // 성공 메시지 표시
  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 에러 메시지 표시
  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 되돌리기 성공 메시지 표시
  static void showUndoSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('복용 기록이 취소되었습니다.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // 날짜 선택 피커
  static Future<DateTime?> showDatePickerModal(
    BuildContext context,
    DateTime initialDate,
    String title,
  ) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
  }

  // 시간 선택 피커
  static Future<Duration?> showTimePickerModal(
    BuildContext context,
    Duration initialTime,
    String title,
  ) async {
    final timeOfDay = TimeOfDay(
      hour: initialTime.inHours,
      minute: initialTime.inMinutes % 60,
    );

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (selectedTime != null) {
      return Duration(hours: selectedTime.hour, minutes: selectedTime.minute);
    }

    return null;
  }
}
