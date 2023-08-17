
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
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                state.isSeller == 0 ? const TopBar() : const SellerTopBar(),
                ProfileCard(user: state.user)
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

class ProfileCard extends StatelessWidget {
  final UserModel user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: SelectableText(
              value,
              style: const TextStyle(fontSize: 16),
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
          const Text(
            'Wallet Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: SelectableText(
              walletAddress,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(
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
