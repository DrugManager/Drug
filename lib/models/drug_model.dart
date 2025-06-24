class Drug {
  final String id;
  final String drugName;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> weekdays; // ['월', '화', '수', '목', '금', '토', '일']
  final String startTime;
  final String endTime;
  final bool isRepeating;
  final int totalDoseCount;
  final int takenDoseCount;
  final bool hasTotalDoseCount; // 총 복용횟수가 있는지 여부
  final DateTime createdAt;

  Drug({
    required this.id,
    required this.drugName,
    required this.startDate,
    required this.endDate,
    required this.weekdays,
    required this.startTime,
    required this.endTime,
    required this.isRepeating,
    required this.totalDoseCount,
    required this.takenDoseCount,
    required this.hasTotalDoseCount,
    required this.createdAt,
  });

  // Firestore에 저장하기 위한 JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'drugName': drugName,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'weekdays': weekdays,
      'startTime': startTime,
      'endTime': endTime,
      'isRepeating': isRepeating,
      'totalDoseCount': totalDoseCount,
      'takenDoseCount': takenDoseCount,
      'hasTotalDoseCount': hasTotalDoseCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Firestore에서 불러오기 위한 JSON 변환
  factory Drug.fromJson(Map<String, dynamic> json, String id) {
    return Drug(
      id: id,
      drugName: json['drugName'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(
        json['startDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      endDate: DateTime.fromMillisecondsSinceEpoch(
        json['endDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      weekdays: List<String>.from(json['weekdays'] ?? []),
      startTime: json['startTime'] ?? '08:00',
      endTime: json['endTime'] ?? '20:00',
      isRepeating: json['isRepeating'] ?? false,
      totalDoseCount: json['totalDoseCount'] ?? 1,
      takenDoseCount: json['takenDoseCount'] ?? 0,
      hasTotalDoseCount: json['hasTotalDoseCount'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  // 기존 코드와의 호환성을 위한 getter들
  String get time => startTime;
  String get day => weekdays.isNotEmpty ? weekdays.first : '월';
}
