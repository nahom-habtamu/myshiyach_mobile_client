import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/domain/contracts/auth.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import 'network_info.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton<Auth>(
    () => AuthRepository(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerFactory(() => NetworkInfo());
  sl.registerLazySingleton(() => AuthRemoteDataSource());
  sl.registerLazySingleton<DataSource>(() => AuthRemoteDataSource());
}
