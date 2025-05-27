class Drug {
  final String id;
  final String drugName;
  final String time;
  final String day;
  final int totalDoseCount;
  final int takenDoseCount;

  Drug({
    required this.id,
    required this.drugName,
    required this.time,
    required this.day,
    required this.totalDoseCount,
    required this.takenDoseCount,
  });
}
