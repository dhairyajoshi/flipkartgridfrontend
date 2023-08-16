// ignore_for_file: prefer_const_constructors

import 'package:flipkartgridfrontend/bloc/auth/signupbloc.dart';
import 'package:flipkartgridfrontend/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/appbloc.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final _referralController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (_repasswordController.text != _passwordController.text) {
      return 'Passwords do not match!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => SignupBloc()..add(AuthCheckEvent(context)),
      child: BlocBuilder<SignupBloc, AppState>(
        builder: (context, state) {
          if (state is SignupState) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'FlipKart',
                          style:
                              TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: _validateName,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: _validateEmail,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone No.',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            validator: _validatePhone,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: _validatePassword,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _repasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: _validatePassword,
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _referralController,
                            decoration: InputDecoration(
                              labelText: 'Referral Code',
                              prefixIcon: Icon(Icons.code),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Signing up as: ',style: TextStyle(fontSize: 16),),
                            Radio<int>(
                              value: 0,
                              groupValue: state.grp,
                              onChanged: (value) {
                                BlocProvider.of<SignupBloc>(context)
                                    .add(SelectRoleEvent(value!));
                              },
                            ),
                            Text('Customer'),
                            Radio<int>(
                              value: 1,
                              groupValue: state.grp,
                              onChanged: (value) {
                                BlocProvider.of<SignupBloc>(context)
                                    .add(SelectRoleEvent(value!));
                              },
                            ),
                            Text('Seller'),
                          ],
                        ),
                        SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<SignupBloc>(context).add(SignupEvent(
                                  context,
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _referralController.text));
                            }
                          },
                          child: Text('Signup'),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already a User?'),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: ((context) => LoginScreen())));
                              },
                              child: Text('Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
