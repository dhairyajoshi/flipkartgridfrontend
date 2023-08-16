// ignore_for_file: prefer_const_constructors

import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/bloc/home/profilebloc.dart';
import 'package:flipkartgridfrontend/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../components/topbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfileEvent()),
      child: BlocBuilder<ProfileBloc, AppState>(
        builder: (context, state) {
          if (state is ProfileLoadedState) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: ListView(
                  shrinkWrap: true,
                  children: [TopBar(), ProfileCard(user: state.user)]),
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

class ProfileCard extends StatelessWidget {
  final UserModel user;

  ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Name', user.name),
            _buildDetailRow('Email', user.email),
            // _buildDetailRow('Phone', user.phone),
            _buildDetailRow(
                'Account Balance', '₹${user.account.toStringAsFixed(2)}'),
            _buildWalletAddressRow(user.walletAddress), // Updated row
            _buildDetailRow('Supercoins', user.supercoins.toString()),
            _buildDetailRow('Referral Code', user.referralCode!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            child: SelectableText(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletAddressRow(String walletAddress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            child: SelectableText(
              walletAddress,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 14,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: walletAddress));
            },
          ),
        ],
      ),
    );
  }
}
