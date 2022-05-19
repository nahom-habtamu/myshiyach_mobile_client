import 'package:get_it/get_it.dart';

import '../../data/datasources/auth_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/firebase_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/contracts/auth.dart';
import '../../domain/usecases/authenticate_phone_number.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/verify_phone_number.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../presentation/bloc/register_user/register_user_cubit.dart';
import '../../presentation/bloc/verify_phone_number/verify_phone_number_cubit.dart';
import 'network_info.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => VerifyPhoneNumberCubit(sl()));
  sl.registerFactory(() => RegisterUserCubit(sl(), sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => VerifyPhoneNumber(sl()));
  sl.registerLazySingleton(() => AuthenticatePhoneNumber(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton<Auth>(
    () => AuthRepository(
        remoteDataSource: sl(), networkInfo: sl(), firebaseDataSource: sl()),
  );
  sl.registerFactory(() => NetworkInfo());
  sl.registerLazySingleton(() => AuthRemoteDataSource());
  sl.registerLazySingleton<FirebaseDataSource>(() => FirebaseDataSouceImpl());
  sl.registerLazySingleton<AuthDataSource>(() => AuthRemoteDataSource());
}
