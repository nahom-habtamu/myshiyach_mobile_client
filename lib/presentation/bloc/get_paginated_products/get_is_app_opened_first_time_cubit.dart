import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_is_app_opened_first_time.dart';

class GetIsAppOpenedFirstTimeCubit extends Cubit {
  final GetIsAppOpenedFirstTime getIsAppOpenedFirstTime;
  GetIsAppOpenedFirstTimeCubit(this.getIsAppOpenedFirstTime) : super(null);

  Future<bool> execute() async {
    return await getIsAppOpenedFirstTime.call();
  }
}
