import 'package:get_it/get_it.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/contracts/auth.dart';
import '../../domain/usecases/login.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
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
  sl.registerLazySingleton<AuthDataSource>(() => AuthRemoteDataSource());
}
