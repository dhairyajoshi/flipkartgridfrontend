
import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/bloc/home/customerbloc.dart';
import 'package:flipkartgridfrontend/components/topbar.dart';
import 'package:flipkartgridfrontend/models/customermodel.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => CustomerBloc()..add(FetchCustomersEvent()),
      child: BlocBuilder<CustomerBloc, AppState>(
        builder: (context, state) {
          if (state is CustomerLoadedState) {
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                state.isSeller == 0 ? const TopBar() : const SellerTopBar(),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Top Customers',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.customers.length,
                    itemBuilder: (context, index) {
                      return CustomerCard(
                        ctx: context,
                        customerId: state.customers[index].customer,
                        customerName: state.customers[index].customerName,
                        totalAmount: state.customers[index].totalAmount,
                        orders: state.customers[index].orders,
                      );
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

class CustomerCard extends StatelessWidget {
  final BuildContext ctx;
  final String customerName;
  final String customerId;
  final double totalAmount;
  final List<TransactionModel> orders;

  const CustomerCard({super.key, 
    required this.ctx,
    required this.customerName,
    required this.customerId,
    required this.totalAmount,
    required this.orders,
  });

  void _showOrderDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details for $customerName'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (var order in orders)
                  ListTile(
                    title: Text(order.name),
                    subtitle: Text('Date: ${order.date}'),
                    trailing: Text('Price: ₹ ${order.price.toStringAsFixed(2)}'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text(customerName),
            subtitle: Text('ID: $customerId'),
            trailing: ElevatedButton(
              onPressed: () {
                BlocProvider.of<CustomerBloc>(ctx)
                    .add(RewardCustomerEvent(ctx, customerId, customerName));
              },
              child: const Text('Reward Customer'),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text('Total Transaction: ₹ ${totalAmount.toStringAsFixed(2)}'),
            onTap: () {
              _showOrderDetailsDialog(context); 
            },
          ),
        ],
      ),
    );
  }
}


class OrderDetailsCard extends StatelessWidget {
  final TransactionModel order;

  const OrderDetailsCard(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(order.name),
      subtitle: Text('Date: ${order.date}'),
      trailing: Text('Price: ₹ ${order.price.toStringAsFixed(2)}'),
    );
  }
}
