import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/models/customermodel.dart';
import 'package:flipkartgridfrontend/models/rewardmodel.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flipkartgridfrontend/models/usermodel.dart';
import 'package:flipkartgridfrontend/screens/login.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerLoadingState extends AppState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CustomerLoadedState extends AppState {
  List<CustomerModel> customers;
  List<bool> expanded;
  int isSeller;
  CustomerLoadedState(this.isSeller, this.customers, this.expanded);
  @override
  // TODO: implement props
  List<Object?> get props => [customers, isSeller, expanded];
}

class FetchCustomersEvent extends AppEvent {}

class RewardCustomerEvent extends AppEvent {
  String id, name;
  BuildContext ctx;
  RewardCustomerEvent(this.ctx, this.id, this.name);
}

class CustomerBloc extends Bloc<AppEvent, AppState> {
  List<CustomerModel> customers = [];
  List<bool> expanded = [];
  int isSeller = 0;
  CustomerBloc() : super(CustomerLoadingState()) {
    on<FetchCustomersEvent>(
      (event, emit) async {
        final customers = await DatabaseService().getTopCustomers();
        final pref = await SharedPreferences.getInstance();
        final role = pref.get('role');
        expanded = List.generate(customers.length, (index) => false);

        role == 'seller' ? isSeller = 1 : isSeller = 0;
        emit(CustomerLoadedState(isSeller, customers, expanded));
      },
    );

    on<RewardCustomerEvent>(
      (event, emit) async {
        int quantity = 0;
        TextEditingController _superController =
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
                title: Text('Reward ${event.name}'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Supercoins: ${tokens}'),
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
                                _superController.text = '0';
                              } else {
                                _superController.text = quantity.toString();
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
                              controller: _superController,
                              onChanged: (value) {
                                try {
                                  quantity = int.parse(value);
                                  if (quantity > int.parse(tokens) ||
                                      quantity < 0) {
                                    quantity = int.parse(tokens);
                                    _superController.text = tokens;
                                  }
                                } catch (e) {
                                  quantity = int.parse(tokens);
                                  _superController.text = tokens;
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
                              _superController.text = tokens;
                            } else {
                              _superController.text = quantity.toString();
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
                    onPressed: () async {
                      final res = await DatabaseService()
                          .rewardCustomer(event.id, quantity);
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
                    },
                    child: Text('Confirm'),
                  ),
                ],
              );
            });
      },
    );
  }
}
