// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/screens/products.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckState extends AppState{
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LoginState extends AppState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginEvent extends AppEvent {
  String email, password;
  BuildContext ctx;
  LoginEvent(this.ctx, this.email, this.password);
}

class AuthCheckEvent extends AppEvent{
  BuildContext ctx;
  AuthCheckEvent(this.ctx);
}

class LoginBloc extends Bloc<AppEvent, AppState> {
  LoginBloc() : super(AuthCheckState()) {
    on<AuthCheckEvent>((event, emit) async{
      final pref =await SharedPreferences.getInstance();
      final token = pref.get('token');

      if(token!=null) {
        Navigator.of(event.ctx).pushReplacement(MaterialPageRoute(builder: ((context) => ProductScreen())));
      }else{
        emit(LoginState());
      }
    },);
    on<LoginEvent>(
      (event, emit) async {
        final res = await DatabaseService()
            .login({'email': event.email, 'password': event.password});

        if (!res) {
          await Flushbar(
            message: 'Wrong Credentials',
            duration: Duration(seconds: 3),
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
          ).show(event.ctx);
        }else{
          Navigator.of(event.ctx).pushReplacement(MaterialPageRoute(builder: ((context) => ProductScreen())));
        }
      }, 
    );
  }
}
