
// ignore_for_file: must_be_immutable

import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/bloc/home/productbloc.dart';
import 'package:flipkartgridfrontend/components/topbar.dart';
import 'package:flipkartgridfrontend/models/productmodel.dart';
import 'package:flipkartgridfrontend/screens/login.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});
  final List<String> options = ['Profile', 'Settings', 'Logout'];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const cardWidth = 300.0;
    final crossAxisCount = (screenWidth / cardWidth).floor();
    const aspectRatio = cardWidth / 355.0;
    return Scaffold(
        body: BlocProvider(
      create: (context) => ProductBloc()..add(FetchProductEvent()),
      child: BlocBuilder<ProductBloc, AppState>(
        builder: (context, state) {
          if (state is ProductLoadedState) {
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(children: [
                const TopBar(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        context,
                        state,
                        state.products[index],
                      );
                    },
                  ),
                )
              ]),
            );
          } else if (state is SellerProductLoadedState) {
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(children: [
                const SellerTopBar(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Products',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          BlocProvider.of<ProductBloc>(context)
                              .add(AddProductEvent(context));
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Product'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.blue.withOpacity(0.8);
                              }
                              return Colors
                                  .transparent;
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.white;
                              }
                              return Colors.blue;
                            },
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return SellerProductCard(
                        context,
                        state,
                        state.products[index],
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
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  BuildContext ctx;
  AppState state;
  ProductCard(this.ctx, this.state, this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 200,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Image.asset(
                    '../assets/product_image_placeholder.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Seller: ${product.sellerName}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ₹ ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(BuyProductEvent(ctx, product));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: const Text('Buy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerProductCard extends StatelessWidget {
  final ProductModel product;
  BuildContext ctx;
  AppState state;
  SellerProductCard(this.ctx, this.state, this.product);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 200,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: Center(
                  child: Image.asset(
                    '../assets/product_image_placeholder.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Seller: ${product.sellerName}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: ₹ ${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.rating.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
