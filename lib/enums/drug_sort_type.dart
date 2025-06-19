enum DrugSortType {
  createdDate('생성순'),
  todayRelevant('오늘 복용'),
  startDate('시작일순'),
  drugName('약 이름순');

  const DrugSortType(this.displayName);
  final String displayName;
}
