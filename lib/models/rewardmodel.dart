class RewardModel {
  final String tokens;
  final String createdAt;
  final String expiryDate;
  final String from;

  RewardModel({
    required this.tokens,
    required this.createdAt,
    required this.expiryDate,
    required this.from,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
        tokens: json['tokens'].toString(),
        createdAt: json['createdAt'],
        expiryDate: json['expiryDate'],
        from: json['from']);
  }

  Map<String, dynamic> toJson() {
    return {
      'tokens': tokens,
      'createdAt': createdAt,
      'expiryDate': expiryDate,
      'from': from
    };
  }
}
