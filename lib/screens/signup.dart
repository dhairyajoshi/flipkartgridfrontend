
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'FlipKart',
                          style:
                              TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: _validateName,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: _validateEmail,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone No.',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            validator: _validatePhone,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: _validatePassword,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _repasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: _validatePassword,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            controller: _referralController,
                            decoration: const InputDecoration(
                              labelText: 'Referral Code',
                              prefixIcon: Icon(Icons.code),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Signing up as: ',style: TextStyle(fontSize: 16),),
                            Radio<int>(
                              value: 0,
                              groupValue: state.grp,
                              onChanged: (value) {
                                BlocProvider.of<SignupBloc>(context)
                                    .add(SelectRoleEvent(value!));
                              },
                            ),
                            const Text('Customer'),
                            Radio<int>(
                              value: 1,
                              groupValue: state.grp,
                              onChanged: (value) {
                                BlocProvider.of<SignupBloc>(context)
                                    .add(SelectRoleEvent(value!));
                              },
                            ),
                            const Text('Seller'),
                          ],
                        ),
                        const SizedBox(height: 25),
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
                          child: const Text('Signup'),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already a User?'),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: ((context) => LoginScreen())));
                              },
                              child: const Text('Login'),
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ));
    ;
  }
}
