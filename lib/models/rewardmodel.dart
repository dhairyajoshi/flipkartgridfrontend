class RewardModel {
  final String tokens;
  final String createdAt;
  final String expiryDate;

  RewardModel({
    required this.tokens,
    required this.createdAt,
    required this.expiryDate,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      tokens: json['tokens'].toString(),
      createdAt: json['createdAt'],
      expiryDate: json['expiryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokens': tokens,
      'createdAt': createdAt,
      'expiryDate': expiryDate,
    };
  }
}