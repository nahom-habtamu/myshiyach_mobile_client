import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/auth/auth_data_source.dart';
import '../../data/datasources/auth/auth_remote_data_source.dart';
import '../../data/datasources/firebase/firebase_auth_data_source.dart';
import '../../data/datasources/product/product_data_source.dart';
import '../../data/datasources/product/product_local_data_source.dart';
import '../../data/datasources/product/product_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/contracts/auth_service.dart';
import '../../domain/contracts/product_service.dart';
import '../../domain/usecases/authenticate_phone_number.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_favorite_products.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/set_favorite_product.dart';
import '../../domain/usecases/verify_phone_number.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../presentation/bloc/get_all_products/get_all_products_cubit.dart';
import '../../presentation/bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../../presentation/bloc/register_user/register_user_cubit.dart';
import '../../presentation/bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../../presentation/bloc/verify_phone_number/verify_phone_number_cubit.dart';
import 'network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // state
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => VerifyPhoneNumberCubit(sl()));
  sl.registerFactory(() => RegisterUserCubit(sl(), sl()));
  sl.registerFactory(() => GetAllProductsCubit(sl()));
  sl.registerFactory(() => GetFavoriteProductsCubit(sl()));
  sl.registerFactory(() => SetFavoriteProductsCubit(sl()));

  // usecases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => VerifyPhoneNumber(sl()));
  sl.registerLazySingleton(() => AuthenticatePhoneNumber(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetFavoriteProducts(sl()));
  sl.registerLazySingleton(() => SetFavoriteProducts(sl()));

  // repositories

  // Auth
  sl.registerLazySingleton<AuthService>(
    () => AuthRepository(
        remoteDataSource: sl(), networkInfo: sl(), firebaseDataSource: sl()),
  );

  // Product
  sl.registerLazySingleton<ProductService>(
    () => ProductRepository(
        remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()),
  );

  // Data Sources

  // Auth
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseDataSouceImpl(),
  );

  sl.registerLazySingleton(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthDataSource>(() => AuthRemoteDataSource());

  // Product
  sl.registerLazySingleton(() => ProductRemoteDataSource());
  sl.registerLazySingleton<ProductDataSource>(() => ProductRemoteDataSource());

  sl.registerLazySingleton(() => ProductLocalDataSource(sl()));

  // Shared Preferences

  var sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // other
  sl.registerFactory(() => NetworkInfo());
}
