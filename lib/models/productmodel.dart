class ProductModel {
  final String id;
  final String name;
  final String sellerId;
  final String sellerName;
  final double price;
  final double rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.sellerId,
    required this.sellerName,
    required this.price,
    this.rating = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      sellerId: json['seller_id'],
      sellerName: json['seller_name'],
      price: json['price'],
      rating: json['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'price': price,
      'rating': rating,
    };
  }
}
