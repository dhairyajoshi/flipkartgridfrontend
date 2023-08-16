import 'dart:convert';

import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/models/usermodel.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileLoadingState extends AppState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProfileLoadedState extends AppState {
  UserModel user;
  ProfileLoadedState(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class LoadProfileEvent extends AppEvent {}

class ProfileBloc extends Bloc<AppEvent, AppState> {
  ProfileBloc() : super(ProfileLoadingState()) {
    on<LoadProfileEvent>(
      (event, emit) async {
        await DatabaseService().getTokens();
        await DatabaseService().updateUser();
        final pref = await SharedPreferences.getInstance();
        final user = UserModel.fromJson(json.decode(pref.getString('user')!));

        emit(ProfileLoadedState(user));
      },
    );
  }
}
