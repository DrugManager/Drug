import 'package:intl/intl.dart';

class DateTimeUtils {
  // 날짜 포맷팅
  static String formatDate(DateTime date) {
    return DateFormat('yyyy년 MM월 dd일').format(date);
  }

  // 시간 포맷팅
  static String formatTime(Duration time) {
    final hours = time.inHours.toString().padLeft(2, '0');
    final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  // Duration 포맷팅
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}시간';
    } else {
      return '${duration.inMinutes}분';
    }
  }

  // 시간 파싱
  static Duration parseTime(String timeString) {
    final parts = timeString.split(':');
    return Duration(
      hours: int.tryParse(parts[0]) ?? 8,
      minutes: int.tryParse(parts[1]) ?? 0,
    );
  }

  // 요일 표시 문자열 생성
  static String buildWeekdaysDisplay(List<String> weekdays) {
    if (weekdays.length == 7) {
      return '매일';
    }

    // 요일을 올바른 순서로 정렬
    const weekdayOrder = ['월', '화', '수', '목', '금', '토', '일'];
    List<String> sortedWeekdays = [];

    for (String day in weekdayOrder) {
      if (weekdays.contains(day)) {
        sortedWeekdays.add(day);
      }
    }

    return sortedWeekdays.join(', ');
  }
}
