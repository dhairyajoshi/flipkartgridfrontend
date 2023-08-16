// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:another_flushbar/flushbar.dart';
import 'package:equatable/equatable.dart';
import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/screens/products.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckState extends AppState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class SignupState extends AppState {
  int grp;
  SignupState(this.grp);
  @override
  // TODO: implement props
  List<Object?> get props => [grp];
}

class SignupEvent extends AppEvent {
  String email, password, name, referral;
  BuildContext ctx;
  SignupEvent(this.ctx, this.name, this.email, this.password, this.referral);
}

class SelectRoleEvent extends AppEvent {
  int g;
  SelectRoleEvent(this.g);
}

class AuthCheckEvent extends AppEvent {
  BuildContext ctx;
  AuthCheckEvent(this.ctx);
}

class SignupBloc extends Bloc<AppEvent, AppState> {
  int grp = 0;
  SignupBloc() : super(AuthCheckState()) {
    on<AuthCheckEvent>(
      (event, emit) async {
        final pref = await SharedPreferences.getInstance();
        final token = pref.get('token');

        if (token != null) {
          Navigator.of(event.ctx).pushReplacement(
              MaterialPageRoute(builder: ((context) => ProductScreen())));
        } else {
          emit(SignupState(grp));
        }
      },
    );
    on<SignupEvent>((event, emit) async {
      final data = {
        'name': event.name,
        "email": event.email,
        "password": event.password,
        "role": grp==1?"seller":"customer"
      };
      if (event.referral != "") data['refId'] = event.referral;
      final res = await DatabaseService().signup(data);
      if (!res['res']) {
        await Flushbar(
          message: res['msg'],
          duration: Duration(seconds: 3),
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
        ).show(event.ctx);
      } else {
        Navigator.of(event.ctx).pushReplacement(
            MaterialPageRoute(builder: ((context) => ProductScreen())));
      }
    });

    on<SelectRoleEvent>(
      (event, emit) {
        grp = event.g;
        emit(SignupState(grp));
      },
    );
  }
}
