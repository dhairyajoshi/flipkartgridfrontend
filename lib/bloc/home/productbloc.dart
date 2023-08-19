// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/models/productmodel.dart';
import 'package:flipkartgridfrontend/models/usermodel.dart';
import 'package:flipkartgridfrontend/screens/login.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductLoadingState extends AppState {
  @override
  List<Object?> get props => [];
}

class ProductLoadedState extends AppState {
  List<ProductModel> products;
  ProductLoadedState(this.products);
  @override
  List<Object?> get props => [products];
}

class SellerProductLoadedState extends AppState {
  List<ProductModel> products;
  SellerProductLoadedState(this.products);
  @override
  List<Object?> get props => [products];
}

class FetchProductEvent extends AppEvent {}

class AddProductEvent extends AppEvent {
  BuildContext ctx;
  AddProductEvent(this.ctx);
}

class BuyProductEvent extends AppEvent {
  BuildContext ctx;
  ProductModel product;

  BuyProductEvent(this.ctx, this.product);
}

class ProductBloc extends Bloc<AppEvent, AppState> {
  List<ProductModel> products = [];

  ProductBloc() : super(ProductLoadingState()) {
    on<FetchProductEvent>(
      (event, emit) async {
        products = await DatabaseService().getAllProducts();
        final pref = await SharedPreferences.getInstance();
        final role = pref.get('role');

        role == 'seller'
            ? emit(SellerProductLoadedState(products))
            : emit(ProductLoadedState(products));
      },
    );

    on<BuyProductEvent>(
      (event, emit) async {
        int quantity = 0;
        bool canBuy = true;
        TextEditingController superController =
            TextEditingController(text: '0');
        final pref = await SharedPreferences.getInstance();
        final token = pref.get('token');
        if (token == null) {
          Navigator.of(event.ctx).pushReplacement(
              MaterialPageRoute(builder: ((context) => LoginScreen())));
        }
        final user = UserModel.fromJson(json.decode(pref.getString('user')!));
        final tokens = await DatabaseService().getTokens();

        await showDialog(
          context: event.ctx,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Place Order'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Product: ${event.product.name}'),
                  Text('Price: ₹ ${event.product.price.toStringAsFixed(2)}'),
                  Text('Account Balance: ₹ ${user.account}'),
                  Text('Supercoins: $tokens'),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Redeem supercoins: '),
                      IconButton(
                        onPressed: () {
                          if (quantity > 0) {
                            quantity--;
                            if (quantity < 0) {
                              quantity = 0;
                              superController.text = '0';
                            } else {
                              superController.text = quantity.toString();
                            }
                          }
                        },
                        icon: Icon(
                          Icons.remove,
                          size: 14,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 38,
                        child: Center(
                          child: TextField(
                            controller: superController,
                            onChanged: (value) {
                              try {
                                quantity = int.parse(value);
                                if (quantity > int.parse(tokens) ||
                                    quantity < 0) {
                                  canBuy = false;
                                  quantity = int.parse(tokens);
                                  superController.text = tokens;
                                }
                              } catch (e) {
                                quantity = int.parse(tokens);
                                superController.text = tokens;
                              }
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          quantity++;
                          if (quantity > int.parse(tokens)) {
                            quantity = int.parse(tokens);
                            superController.text = tokens;
                          } else {
                            superController.text = quantity.toString();
                          }
                        },
                        icon: Icon(
                          Icons.add,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: canBuy
                      ? () async {
                          final res = await DatabaseService().buyProduct({
                            'productId': event.product.id,
                            'supercoins': quantity
                          });
                          await Flushbar(
                            message: res,
                            duration: Duration(seconds: 3),
                            flushbarPosition: FlushbarPosition.TOP,
                            flushbarStyle: FlushbarStyle.FLOATING,
                            backgroundColor: Colors.red,
                            icon: Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          ).show(event.ctx);

                          Navigator.of(context).pop();
                          await DatabaseService().updateUser();
                        }
                      : null,
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    on<AddProductEvent>(
      (event, emit) async {
        await showDialog(
          context: event.ctx,
          builder: (BuildContext context) {
            TextEditingController productNameController =
                TextEditingController();
            TextEditingController priceController = TextEditingController();
            TextEditingController ratingController = TextEditingController();

            return AlertDialog(
              title: Text('Add New Product'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: productNameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: ratingController,
                    decoration: InputDecoration(labelText: 'Rating'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String productName = productNameController.text;
                    double price = double.tryParse(priceController.text) ?? 0.0;
                    double rating =
                        double.tryParse(ratingController.text) ?? 0.0;

                    final res = await DatabaseService().addProduct(
                        productName: productName, price: price, rating: rating);

                    await Flushbar(
                      message: res,
                      duration: Duration(seconds: 3),
                      flushbarPosition: FlushbarPosition.TOP,
                      flushbarStyle: FlushbarStyle.FLOATING,
                      backgroundColor: Colors.red,
                      icon: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    ).show(event.ctx);

                    Navigator.of(context).pop();
                    add(FetchProductEvent());
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
