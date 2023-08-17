import 'package:flipkartgridfrontend/bloc/appbloc.dart';
import 'package:flipkartgridfrontend/models/rewardmodel.dart';
import 'package:flipkartgridfrontend/models/transactionmodel.dart';
import 'package:flipkartgridfrontend/services/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardLoadingState extends AppState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class RewardLoadedState extends AppState{
  List<RewardModel> rewards;
  String totalReward;
  int isSeller;
  RewardLoadedState(this.isSeller,this.totalReward,this.rewards);
  @override
  // TODO: implement props
  List<Object?> get props => [rewards];
}

class FetchRewardsEvent extends AppEvent{}

class RewardBloc extends Bloc<AppEvent,AppState>{
  List<RewardModel> rewards=[];
  int isSeller=0;
  RewardBloc():super(RewardLoadingState()){
    on<FetchRewardsEvent>((event, emit) async{
      final data = await DatabaseService().getRewardHistory();
      final pref = await SharedPreferences.getInstance();
      rewards = data['rewards'];
      final total = data['total'];
      final role = pref.get('role');

        role == 'seller' ? isSeller = 1 : isSeller = 0;
      emit(RewardLoadedState(isSeller,total,rewards));
    },);
  }
}