import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderLoadingState extends AppState {
  @override
  List<Object?> get props => [];
}

class OrderLoadedState extends AppState {
  List<TransactionModel> orders;
  OrderLoadedState(this.orders);
  @override
  List<Object?> get props => [orders];
}

class SellerOrderLoadedState extends AppState {
  List<TransactionModel> orders;
  SellerOrderLoadedState(this.orders);
  @override
  List<Object?> get props => [orders];
}

class FetchOrdersEvent extends AppEvent {}

class OrderBloc extends Bloc<AppEvent, AppState> {
  List<TransactionModel> orders = [];
  OrderBloc() : super(OrderLoadingState()) {
    on<FetchOrdersEvent>(
      (event, emit) async {
        orders = await DatabaseService().getOrders();
        final pref = await SharedPreferences.getInstance();
        final role = pref.get('role');
        role == 'seller'
            ? emit(SellerOrderLoadedState(orders))
            : emit(OrderLoadedState(orders));
      },
    );
  }
}
