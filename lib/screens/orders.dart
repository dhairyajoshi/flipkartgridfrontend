// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/bloc/home/orderbloc.dart';
import 'package:flipkartgridfrontend/components/topbar.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => OrderBloc()..add(FetchOrdersEvent()),
      child: BlocBuilder<OrderBloc, AppState>(
        builder: (context, state) {
          if (state is OrderLoadedState) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                TopBar(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      return TransactionCard(transaction: state.orders[index]);
                    },
                  ),
                )
              ]),
            );
          } else if (state is SellerOrderLoadedState) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                TopBar(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      return SellerTransactionCard(
                          transaction: state.orders[index]);
                    },
                  ),
                )
              ]),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ));
    ;
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  transaction.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Seller: ${transaction.sellerName}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Date: ${transaction.date}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Price: ₹${transaction.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Supercoins: ${transaction.supercoins.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Spacer(),
                Text(
                  'Reward Earned: ${transaction.rewardEarned.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class SellerTransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  SellerTransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  transaction.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Buyer Id: ${transaction.userId}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Date: ${transaction.date}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Price: ₹${transaction.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Reward Earned: ${transaction.rewardEarned.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
