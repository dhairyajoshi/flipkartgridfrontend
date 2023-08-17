import 'package:flipkartgridfrontend/models/transactionmodel.dart';

class CustomerModel {
  String customerName;
  String customer;
  double totalAmount;
  List<TransactionModel> orders;

  CustomerModel({
    required this.customerName,
    required this.customer,
    required this.totalAmount,
    required this.orders,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerName: json['customerName'],
      customer: json['customer'],
      totalAmount: json['totalAmount'].toDouble(),
      orders: (json['orders'] as List<dynamic>)
          .map((order) => TransactionModel.fromJson(order))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customer': customer,
      'totalAmount': totalAmount,
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }
}
