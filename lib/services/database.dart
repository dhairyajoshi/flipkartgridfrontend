import 'dart:convert';
import 'package:flipkartgridfrontend/models/customermodel.dart';
import 'package:flipkartgridfrontend/models/productmodel.dart';
import 'package:flipkartgridfrontend/models/rewardmodel.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flipkartgridfrontend/models/usermodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final baseUrl = 'http://localhost:3000';

  Future<bool> login(Map<String, String> data) async {
    final response =
        await http.post(Uri.parse('$baseUrl/user/login'), body: data);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = UserModel.fromJson(data['user']);
      final pref = await SharedPreferences.getInstance();
      pref.setString('token', data['token']);
      pref.setString('role', data['user']['role']);
      pref.setString('user', json.encode(user.toJson()));
      return true;
    }
    return false;
  }

  Future<Map<String, dynamic>> signup(Map<String, String> data) async {
    final response =
        await http.post(Uri.parse('$baseUrl/user/signup'), body: data);
    final jsondata = json.decode(response.body);
    if (response.statusCode == 201) {
      final user = UserModel.fromJson(jsondata['user']);
      final pref = await SharedPreferences.getInstance();
      pref.setString('token', jsondata['token']);
      pref.setString('user', json.encode(user.toJson()));
      pref.setString('role', jsondata['user']['role']);
      return {'res': true, 'msg': ''};
    }
    return {'res': false, 'msg': jsondata['msg']};
  }

  logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('token');
    pref.remove('user');
  }

  Future<String> getTokens() async {
    final pref = await SharedPreferences.getInstance();

    final res = await http.get(Uri.parse('$baseUrl/contract/gettokens'),
        headers: {'Authorization': 'Bearer ${pref.get('token')}'});

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      return data['tokens'];
    }

    return "0";
  }

  Future<List<ProductModel>> getAllProducts() async {
    List<ProductModel> products = [];
    final pref = await SharedPreferences.getInstance();
    final res = await http.get(Uri.parse('$baseUrl/product/getall'),
        headers: {'Authorization': 'Bearer ${pref.get('token')}'});

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      for (int i = 0; i < data.length; i++) {
        products.add(ProductModel.fromJson(data['$i']));
      }
    }

    return products;
  }

  Future<String> buyProduct(Map<String, dynamic> data) async {
    final pref = await SharedPreferences.getInstance();
    final headers = <String, String>{
      'Authorization': 'Bearer ${pref.get('token')}',
      'content-type': 'application/json'
    };
    final res = await http.post(Uri.parse('$baseUrl/product/buy'),
        headers: headers, body: json.encode(data));

    final jsondata = json.decode(res.body);

    return jsondata['msg'];
  }

  Future<String> addProduct({
    required String productName,
    required double price,
    required double rating,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final res = await http.post(
      Uri.parse('$baseUrl/seller/addproduct'),
      headers: {
        'Authorization': 'Bearer ${pref.get('token')}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': productName,
        'price': price,
        'rating': rating,
      }),
    );

    final responseData = json.decode(res.body);
    return responseData['msg'];
  }

  Future<List<TransactionModel>> getOrders() async {
    final pref = await SharedPreferences.getInstance();
    final headers = <String, String>{
      'Authorization': 'Bearer ${pref.get('token')}'
    };
    final res =
        await http.get(Uri.parse('$baseUrl/user/allorders'), headers: headers);
    final List<TransactionModel> orders = [];

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      for (int i = 0; i < data.length; i++) {
        orders.insert(0, TransactionModel.fromJson(data['$i']));
      }
    }

    return orders;
  }

  updateUser() async {
    final pref = await SharedPreferences.getInstance();
    final headers = <String, String>{
      'Authorization': 'Bearer ${pref.get('token')}'
    };
    final res =
        await http.get(Uri.parse('$baseUrl/user/cur'), headers: headers);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      pref.setString('user', json.encode(data));
    }
  }

  Future<Map<String, dynamic>> getRewardHistory() async {
    final pref = await SharedPreferences.getInstance();
    final headers = <String, String>{
      'Authorization': 'Bearer ${pref.get('token')}'
    };
    List<RewardModel> rewards = [];
    final res = await http.get(Uri.parse('$baseUrl/contract/rewardhistory'),
        headers: headers);
    String totalEarning;
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      totalEarning = data['totalEarning'];
      for (int i = 0; i < data['earningHistory'].length; i++) {
        rewards.insert(0, RewardModel.fromJson(data['earningHistory'][i]));
      }
      return {'total': totalEarning, 'rewards': rewards};
    }

    return {'total': 0, 'rewards': rewards};
  }

  Future<List<CustomerModel>> getTopCustomers() async {
    final pref = await SharedPreferences.getInstance();
    final headers = {'Authorization': 'Bearer ${pref.get('token')}'};
    final List<CustomerModel> customers = [];
    final response = await http.get(
      Uri.parse('$baseUrl/seller/topcustomers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      for (var item in data) {
        final String customerName = item['customerName'];
        final String customerId = item['customer'];
        final double totalAmount = item['totalAmount'];
        final List<TransactionModel> orders = [];

        for (var orderData in item['orders']) {
          final TransactionModel order = TransactionModel.fromJson(orderData);
          orders.add(order);
        }

        final CustomerModel customer = CustomerModel(
          customerName: customerName,
          customer: customerId,
          totalAmount: totalAmount,
          orders: orders,
        );

        customers.add(customer);
      }

      return customers;
    }

    return customers;
  }

  Future<String> rewardCustomer(String customerId, int supercoins) async {
    final pref = await SharedPreferences.getInstance();
    final headers = <String, String>{
      'Authorization': 'Bearer ${pref.get('token')}',
      'content-type': 'application/json'
    };

    final data = {"customerId": customerId, "supercoins": supercoins};

    final res = await http.post(Uri.parse('$baseUrl/seller/rewardcustomer'),
        headers: headers, body: json.encode(data));

    final jsondata = json.decode(res.body);

    return jsondata['msg'];
  }
}
