// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/bloc/home/rewardbloc.dart';
import 'package:flipkartgridfrontend/components/topbar.dart';
import 'package:flipkartgridfrontend/models/rewardmodel.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => RewardBloc()..add(FetchRewardsEvent()),
      child: BlocBuilder<RewardBloc, AppState>(
        builder: (context, state) {
          if (state is RewardLoadedState) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                TopBar(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Total Rewards Earned: ${state.totalReward}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.rewards.length,
                    itemBuilder: (context, index) {
                      return RewardCard(reward: state.rewards[index]);
                    },
                  ),
                )
              ]),
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

class RewardCard extends StatelessWidget {
  final RewardModel reward;

  RewardCard({required this.reward});

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
              'Reward Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildDetailRow('Tokens:', reward.tokens),
            _buildDetailRow('Created At:', reward.createdAt),
            _buildDetailRow('Expiry Date:', reward.expiryDate),
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
          SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
