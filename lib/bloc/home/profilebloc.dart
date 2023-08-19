import 'dart:convert';

import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/models/usermodel.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLoadingState extends AppState {
  @override
  List<Object?> get props => [];
}

class ProfileLoadedState extends AppState {
  int isSeller;
  UserModel user;
  ProfileLoadedState(this.isSeller, this.user);

  @override
  List<Object?> get props => [isSeller, user];
}

class LoadProfileEvent extends AppEvent {}

class ProfileBloc extends Bloc<AppEvent, AppState> {
  int isSeller = 0;
  ProfileBloc() : super(ProfileLoadingState()) {
    on<LoadProfileEvent>(
      (event, emit) async {
        await DatabaseService().getTokens();
        await DatabaseService().updateUser();
        final pref = await SharedPreferences.getInstance();
        final user = UserModel.fromJson(json.decode(pref.getString('user')!));
        final role = pref.get('role');

        role == 'seller' ? isSeller = 1 : isSeller = 0;
        emit(ProfileLoadedState(isSeller, user));
      },
    );
  }
}
