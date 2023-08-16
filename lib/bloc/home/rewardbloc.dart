import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/models/rewardmodel.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardLoadingState extends AppState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class RewardLoadedState extends AppState{
  List<RewardModel> rewards;
  String totalReward;
  RewardLoadedState(this.totalReward,this.rewards);
  @override
  // TODO: implement props
  List<Object?> get props => [rewards];
}

class FetchRewardsEvent extends AppEvent{}

class RewardBloc extends Bloc<AppEvent,AppState>{
  List<RewardModel> rewards=[];
  RewardBloc():super(RewardLoadingState()){
    on<FetchRewardsEvent>((event, emit) async{
      final data = await DatabaseService().getRewardHistory();
      rewards = data['rewards'];
      final total = data['total'];
      emit(RewardLoadedState(total,rewards));
    },);
  }
}