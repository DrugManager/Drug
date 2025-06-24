import 'package:flutter/material.dart';
import 'package:drug/resources/colors.dart';

class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

class TodayStatusWidget extends StatelessWidget {
  final bool canTake;
  final bool isTodayInRange;

  const TodayStatusWidget({
    super.key,
    required this.canTake,
    required this.isTodayInRange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          canTake ? Icons.check_circle : Icons.info,
          color: canTake ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          '오늘 복용 상태',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: canTake ? Colors.green[700] : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class ActionButtonsWidget extends StatelessWidget {
  final bool canTake;
  final bool isLoading;
  final int takenDoseCount;
  final VoidCallback onTakeDose;
  final VoidCallback onUndoTakeDose;

  const ActionButtonsWidget({
    super.key,
    required this.canTake,
    required this.isLoading,
    required this.takenDoseCount,
    required this.onTakeDose,
    required this.onUndoTakeDose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 복용 완료 버튼
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: canTake && !isLoading ? onTakeDose : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canTake ? mainColor : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                        canTake ? '복용 완료' : '복용 불가',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 되돌리기 버튼
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: takenDoseCount > 0 ? onUndoTakeDose : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(
                  color:
                      takenDoseCount > 0
                          ? Colors.grey[700]!
                          : Colors.grey[400]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '되돌리기',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
