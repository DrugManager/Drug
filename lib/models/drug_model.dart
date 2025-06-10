class Drug {
  final String id;
  final String drugName;
  final String time;
  final String day;
  final int totalDoseCount;
  final int takenDoseCount;
  final DateTime createdAt; // 생성날짜 추가

  Drug({
    required this.id,
    required this.drugName,
    required this.time,
    required this.day,
    required this.totalDoseCount,
    required this.takenDoseCount,
    required this.createdAt,
  });

  // Firestore에 저장하기 위한 JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'drugName': drugName,
      'time': time,
      'day': day,
      'totalDoseCount': totalDoseCount,
      'takenDoseCount': takenDoseCount,
      'createdAt': createdAt.millisecondsSinceEpoch, // 타임스탬프로 저장
    };
  }

  // Firestore에서 불러오기 위한 JSON 변환
  factory Drug.fromJson(Map<String, dynamic> json, String id) {
    return Drug(
      id: id,
      drugName: json['drugName'] ?? '',
      time: json['time'] ?? '',
      day: json['day'] ?? '',
      totalDoseCount: json['totalDoseCount'] ?? 0,
      takenDoseCount: json['takenDoseCount'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
