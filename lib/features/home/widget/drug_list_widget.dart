import 'package:flutter/material.dart';

Widget drugList() {
  return ListView.separated(
    padding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 12,
    ), // 양옆, 위아래 여백
    itemCount: 3,
    separatorBuilder:
        (context, index) => const Divider(
          thickness: 1,
          height: 24, // 줄과 줄 사이 간격
          color: Color.fromARGB(255, 196, 196, 196),
        ),
    itemBuilder: (context, index) {
      final drugs = [
        {
          'drugName': '약 이름 1',
          'time': '08:00',
          'day': '월',
          'totalDoseCount': 3,
          'takenDoseCount': 1,
        },
        {
          'drugName': '약 이름 2',
          'time': '12:00',
          'day': '화',
          'totalDoseCount': 2,
          'takenDoseCount': 0,
        },
        {
          'drugName': '약 이름 3',
          'time': '18:00',
          'day': '수',
          'totalDoseCount': 1,
          'takenDoseCount': 1,
        },
      ];
      final drug = drugs[index];
      return drugItem(
        drugName: drug['drugName'] as String,
        time: drug['time'] as String,
        day: drug['day'] as String,
        totalDoseCount: drug['totalDoseCount'] as int,
        takenDoseCount: drug['takenDoseCount'] as int,
      );
    },
  );
}

Widget drugItem({
  required String drugName,
  required String time,
  required String day,
  required int totalDoseCount, // 총 복용 횟수
  required int takenDoseCount, // 복용한 횟수
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Row(
      children: [
        // 왼쪽: 약 이름과 시간
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drugName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
        // 오른쪽: 요일과 복용 횟수
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.teal[200], // 원하는 색상으로 변경 가능
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$takenDoseCount / $totalDoseCount',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ],
    ),
  );
}
