import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/bloc/home/rewardbloc.dart';
import 'package:flipkartgridfrontend/components/topbar.dart';
import 'package:flipkartgridfrontend/models/rewardmodel.dart';
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
            return SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(shrinkWrap: true, children: [
                state.isSeller == 0 ? const TopBar() : const SellerTopBar(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Total Rewards Earned: ${state.totalReward}',
                    style: const TextStyle(fontSize: 20),
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
          return const Center(
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

  const RewardCard({super.key, required this.reward});

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
              'Reward Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Supercoins:', reward.tokens),
            _buildDetailRow('Received:', reward.received),
            _buildDetailRow('From:', reward.from),
            _buildDetailRow('Received At:', reward.createdAt),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
