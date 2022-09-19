import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/set_is_app_opened_first_time.dart';

class SetIsAppOpenedFirstTimeCubit extends Cubit {
  final SetIsAppOpenedFirstTime setIsAppOpenedFirstTime;
  SetIsAppOpenedFirstTimeCubit(this.setIsAppOpenedFirstTime) : super(null);

  void execute() async {
    await setIsAppOpenedFirstTime.call();
  }
}
