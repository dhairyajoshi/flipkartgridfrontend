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
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                const TopBar(),
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
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                const SellerTopBar(),
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
          return const Center(
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

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Seller: ${transaction.sellerName}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Purchase Date: ${transaction.date.replaceFirst(RegExp(r'\s'), '/').replaceFirst(RegExp(r'\s'), '/')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: ₹${transaction.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Supercoins: ${transaction.supercoins}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                Text(
                  'Reward Earned: ${transaction.rewardEarned}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class SellerTransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const SellerTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Buyer Id: ${transaction.userId}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Date: ${transaction.date.replaceFirst(RegExp(r'\s'), '/').replaceFirst(RegExp(r'\s'), '/')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: ₹${transaction.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Reward Earned: ${transaction.rewardEarned.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
