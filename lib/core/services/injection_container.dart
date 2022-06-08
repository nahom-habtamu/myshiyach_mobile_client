import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/auth/auth_data_source.dart';
import '../../data/datasources/auth/auth_remote_data_source.dart';
import '../../data/datasources/auth/firebase_auth_data_source.dart';
import '../../data/datasources/category/category_data_source.dart';
import '../../data/datasources/category/category_remote_data_source.dart';
import '../../data/datasources/city/city_data_source.dart';
import '../../data/datasources/city/city_remote_data_source.dart';
import '../../data/datasources/conversation/conversation_data_source.dart';
import '../../data/datasources/conversation/conversation_firebase_data_source.dart';
import '../../data/datasources/firebase/firebase_storage_data_source.dart';
import '../../data/datasources/product/product_data_source.dart';
import '../../data/datasources/product/product_local_data_source.dart';
import '../../data/datasources/product/product_remote_data_source.dart';
import '../../data/datasources/user/user_local_data_source.dart';
import '../../data/datasources/user/user_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/city_repository.dart';
import '../../data/repositories/conversation_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/token_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/contracts/auth_service.dart';
import '../../domain/contracts/category_service.dart';
import '../../domain/contracts/city_service.dart';
import '../../domain/contracts/conversation_service.dart';
import '../../domain/contracts/product_service.dart';
import '../../domain/contracts/token_service.dart';
import '../../domain/contracts/user_service.dart';
import '../../domain/usecases/add_message_to_conversation.dart';
import '../../domain/usecases/authenticate_phone_number.dart';
import '../../domain/usecases/create_conversation.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product_by_id.dart';
import '../../domain/usecases/extract_token.dart';
import '../../domain/usecases/get_all_cities.dart';
import '../../domain/usecases/get_all_conversations.dart';
import '../../domain/usecases/get_all_products.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_conversation_by_id.dart';
import '../../domain/usecases/get_conversation_by_members.dart';
import '../../domain/usecases/get_favorite_products.dart';
import '../../domain/usecases/get_stored_user_credentials.dart';
import '../../domain/usecases/get_user_by_id.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/set_favorite_product.dart';
import '../../domain/usecases/store_user_credentails.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/upload_product_pictures.dart';
import '../../domain/usecases/verify_phone_number.dart';
import '../../presentation/bloc/add_message_to_conversation/add_message_to_conversation_cubit.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../presentation/bloc/create_conversation/handle_going_to_message_cubit.dart';
import '../../presentation/bloc/create_product/create_product_cubit.dart';
import '../../presentation/bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../../presentation/bloc/display_all_products/display_all_products_cubit.dart';
import '../../presentation/bloc/get_all_categories/get_all_categories_cubit.dart';
import '../../presentation/bloc/get_all_conversations/get_all_conversations_cubit.dart';
import '../../presentation/bloc/get_all_products/get_all_products_cubit.dart';
import '../../presentation/bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../../presentation/bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import '../../presentation/bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../../presentation/bloc/get_user_by_id/get_user_by_id_cubit.dart';
import '../../presentation/bloc/register_user/register_user_cubit.dart';
import '../../presentation/bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../../presentation/bloc/update_product/update_product_cubit.dart';
import '../../presentation/bloc/verify_phone_number/verify_phone_number_cubit.dart';
import 'network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // state
  sl.registerFactory(
    () => AuthCubit(
        extractToken: sl(),
        getCurrentUser: sl(),
        login: sl(),
        getStoredUserCredentials: sl(),
        storeUserCredentials: sl()),
  );
  sl.registerFactory(() => VerifyPhoneNumberCubit(sl()));
  sl.registerFactory(() => RegisterUserCubit(sl(), sl()));
  sl.registerFactory(() => DisplayAllProductsCubit(sl(), sl(), sl()));
  sl.registerFactory(() => GetAllProductsCubit(sl()));
  sl.registerFactory(() => GetFavoriteProductsCubit(sl()));
  sl.registerFactory(() => SetFavoriteProductsCubit(sl()));
  sl.registerFactory(() =>
      UpdateProductCubit(updateProduct: sl(), uploadProductPictures: sl()));
  sl.registerFactory(
    () => GetDataNeededToManagePostCubit(
      getAllCategories: sl(),
      getAllCities: sl(),
    ),
  );
  sl.registerFactory(() => GetAllConversationsCubit(sl()));
  sl.registerFactory(() => GetUserByIdCubit(sl()));
  sl.registerFactory(() => AddMessageToConversationCubit(sl()));
  sl.registerFactory(() => GetConversationByIdCubit(sl()));
  sl.registerFactory(() => DeleteProductByIdCubit(sl()));
  sl.registerFactory(() => GetAllCategoriesCubit(sl()));
  sl.registerFactory(() => UpdateProduct(sl()));
  sl.registerFactory(() => HandleGoingToMessageCubit(
        createConversation: sl(),
        getConversationByMembers: sl(),
        getUserById: sl(),
      ));
  sl.registerFactory(
    () => CreateProductCubit(
      createProduct: sl(),
      uploadProductPictures: sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerLazySingleton(() => VerifyPhoneNumber(sl()));
  sl.registerLazySingleton(() => AuthenticatePhoneNumber(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetFavoriteProducts(sl()));
  sl.registerLazySingleton(() => SetFavoriteProducts(sl()));
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UploadProductPictures(sl()));
  sl.registerLazySingleton(() => GetAllConversations(sl()));
  sl.registerLazySingleton(() => ExtractToken(sl()));
  sl.registerLazySingleton(() => AddMessageToConversation(sl()));
  sl.registerLazySingleton(() => GetConversationById(sl()));
  sl.registerLazySingleton(() => DeleteProductById(sl()));
  sl.registerLazySingleton(() => GetAllCities(sl()));
  sl.registerLazySingleton(() => CreateConversation(sl()));
  sl.registerLazySingleton(() => GetConversationByMembers(sl()));
  sl.registerLazySingleton(() => GetStoredUserCredentials(sl()));
  sl.registerLazySingleton(() => StoreUserCredentials(sl()));

  // repositories

  // Auth
  sl.registerLazySingleton<AuthService>(
    () => AuthRepository(
      remoteDataSource: sl(),
      networkInfo: sl(),
      firebaseDataSource: sl(),
    ),
  );

  // City Service
  sl.registerLazySingleton<CityService>(
    () => CityRepository(sl()),
  );

  // Conversation Service

  sl.registerLazySingleton<ConversationService>(
    () => ConversationRepository(sl()),
  );

  // Token Service

  sl.registerLazySingleton<TokenService>(
    () => TokenRepository(),
  );

  // User Service

  sl.registerLazySingleton<UserService>(
    () => UserRepository(localDataSource: sl(), remoteDataSource: sl()),
  );

  // Product Service
  sl.registerLazySingleton<ProductService>(
    () => ProductRepository(
      remoteDataSource: sl(),
      networkInfo: sl(),
      localDataSource: sl(),
      storageService: sl(),
    ),
  );

  // Category
  sl.registerLazySingleton<CategoryService>(
    () => CategoryRepository(remoteDataSource: sl()),
  );

  // Data Sources

  // Auth
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseDataSouceImpl(),
  );

  // City

  sl.registerLazySingleton<CityDataSource>(
    () => CityRemoteDataSource(),
  );

  // Converations

  sl.registerLazySingleton<ConversationDataSource>(
    () => ConversationFirebaseDataSource(sl()),
  );

  // UPLOAD SERVICE
  sl.registerLazySingleton<StorageDataSource>(
    () => FirebaseStorageDataSource(),
  );

  //  User
  sl.registerLazySingleton(() => UserRemoteDataSource());
  sl.registerLazySingleton(() => UserLocalDataSource(sl()));

  // Auth

  sl.registerLazySingleton(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthDataSource>(() => AuthRemoteDataSource());

  // Product
  sl.registerLazySingleton(() => ProductRemoteDataSource());
  sl.registerLazySingleton<ProductDataSource>(() => ProductRemoteDataSource());

  sl.registerLazySingleton(() => ProductLocalDataSource(sl()));

  // Category

  sl.registerLazySingleton<CategoryDataSource>(
      () => CategoryRemoteDataSource());

  // Shared Preferences

  var sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Firestore Instance

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // other
  sl.registerFactory(() => NetworkInfo());
}
