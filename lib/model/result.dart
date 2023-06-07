class Result {
  String? name;
  DateTime? birthDay;
  Duration? birthTime;
  int? birthPoint;
  List<String>? selectedCards;
  int? cardPoint;
  int? randomPoint;
  int? lottoPoint;
  Result({
    required this.name,
    required this.birthDay,
    required this.birthTime,
    required this.birthPoint,
    required this.selectedCards,
    required this.cardPoint,
    required this.randomPoint,
    required this.lottoPoint,
  });

  int? get totalPoint {
    if (birthPoint != null && cardPoint != null && randomPoint != null) {
      return birthPoint! + cardPoint! + randomPoint!;
    } else {
      return null;
    }
  }
}
