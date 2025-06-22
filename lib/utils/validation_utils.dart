class ValidationUtils {
  // 약 이름 유효성 검사
  static String? validateDrugName(String? drugName) {
    if (drugName == null || drugName.trim().isEmpty) {
      return '약 이름을 입력해주세요';
    }
    return null;
  }

  // 요일 선택 유효성 검사
  static String? validateWeekdays(Set<String> selectedWeekdays) {
    if (selectedWeekdays.isEmpty) {
      return '복용할 요일을 선택해주세요';
    }
    return null;
  }

  // 총 복용횟수 유효성 검사
  static String? validateTotalDoseCount(String? value, bool isRequired) {
    if (isRequired) {
      if (value == null || value.trim().isEmpty) {
        return '총 복용횟수를 입력해주세요';
      }
      final count = int.tryParse(value);
      if (count == null || count <= 0) {
        return '올바른 숫자를 입력해주세요';
      }
    }
    return null;
  }

  // 입력 전체 유효성 검사
  static bool validateInput(String drugName, Set<String> selectedWeekdays) {
    return validateDrugName(drugName) == null &&
        validateWeekdays(selectedWeekdays) == null;
  }
}
