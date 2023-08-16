class TransactionModel {
  String id;
  String name;
  String userId;
  String productId;
  String sellerName;
  String date;
  double price;
  double supercoins;
  double rewardEarned;

  TransactionModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.productId,
    required this.sellerName,
    required this.date,
    required this.price,
    required this.supercoins,
    required this.rewardEarned,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'],
      name: json['name'],
      userId: json['user'],
      productId: json['product'],
      sellerName: json['seller_name'],
      date: json['date'],
      price: json['price'],
      supercoins: json['supercoins'],
      rewardEarned: json['rewardEarned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'user': userId,
      'product': productId,
      'seller_name': sellerName,
      'date': date,
      'price': price,
      'supercoins': supercoins,
      'rewardEarned': rewardEarned,
    };
  }
}
