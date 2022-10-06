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
import '../../data/datasources/firebase/firebase_dynamic_link_data_souce.dart';
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
import '../../data/repositories/upload_pictures_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/contracts/auth_service.dart';
import '../../domain/contracts/category_service.dart';
import '../../domain/contracts/city_service.dart';
import '../../domain/contracts/conversation_service.dart';
import '../../domain/contracts/product_service.dart';
import '../../domain/contracts/token_service.dart';
import '../../domain/contracts/upload_pictures_service.dart';
import '../../domain/contracts/user_service.dart';
import '../../domain/usecases/add_message_to_conversation.dart';
import '../../domain/usecases/authenticate_phone_number.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/create_conversation.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product_by_id.dart';
import '../../domain/usecases/extract_token.dart';
import '../../domain/usecases/filter_products.dart';
import '../../domain/usecases/generate_share_link_for_product.dart';
import '../../domain/usecases/get_all_cities.dart';
import '../../domain/usecases/get_all_conversations.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_conversation_by_id.dart';
import '../../domain/usecases/get_conversation_by_members.dart';
import '../../domain/usecases/get_favorite_products.dart';
import '../../domain/usecases/get_is_app_opened_first_time.dart';
import '../../domain/usecases/get_paginated_products.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/get_products_by_category.dart';
import '../../domain/usecases/get_products_by_user_id.dart';
import '../../domain/usecases/get_stored_user_credentials.dart';
import '../../domain/usecases/get_user_by_id.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/mark_messages_as_read.dart';
import '../../domain/usecases/refresh_product.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/set_favorite_product.dart';
import '../../domain/usecases/set_is_app_opened_first_time.dart';
import '../../domain/usecases/store_user_credentails.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/upload_pictures.dart';
import '../../domain/usecases/verify_phone_number.dart';
import '../../presentation/bloc/add_message_to_conversation/add_image_message_to_conversation_cubit.dart';
import '../../presentation/bloc/add_message_to_conversation/add_text_message_to_conversation_cubit.dart';
import '../../presentation/bloc/auth/auth_cubit.dart';
import '../../presentation/bloc/authenticate_phone_number/authenticate_phone_number.cubit.dart';
import '../../presentation/bloc/change_language/change_language_cubit.dart';
import '../../presentation/bloc/change_password/change_password_cubit.dart';
import '../../presentation/bloc/create_product/create_product_cubit.dart';
import '../../presentation/bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../../presentation/bloc/display_all_products/display_all_products_cubit.dart';
import '../../presentation/bloc/filter/filter_products_cubit.dart';
import '../../presentation/bloc/generate_share_link_for_product/generate_share_link_for_product_cubit.dart';
import '../../presentation/bloc/get_all_categories/get_all_categories_cubit.dart';
import '../../presentation/bloc/get_all_conversations/get_all_conversations_cubit.dart';
import '../../presentation/bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../../presentation/bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import '../../presentation/bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../../presentation/bloc/get_paginated_products/get_is_app_opened_first_time_cubit.dart';
import '../../presentation/bloc/get_paginated_products/get_paginated_products_cubit.dart';
import '../../presentation/bloc/get_post_detail_content/get_post_detail_content_cubit.dart';
import '../../presentation/bloc/get_product_by_id/get_product_by_id_cubit.dart';
import '../../presentation/bloc/get_products_by_category/get_products_by_category_cubit.dart';
import '../../presentation/bloc/get_products_by_user_id/get_products_by_user_id_cubit.dart';
import '../../presentation/bloc/get_user_and_products_by_user_id/get_user_and_products_by_user_id_cubit.dart';
import '../../presentation/bloc/get_user_by_id/get_user_by_id_cubit.dart';
import '../../presentation/bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../../presentation/bloc/logout/logout_cubit.dart';
import '../../presentation/bloc/mark_messages_as_read/mark_messages_as_read_cubit.dart';
import '../../presentation/bloc/refresh_product/refresh_product_cubit.dart';
import '../../presentation/bloc/register_user/register_user_cubit.dart';
import '../../presentation/bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../../presentation/bloc/set_is_app_opened_first_time/set_is_app_opened_first_time_cubit.dart';
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
      storeUserCredentials: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerFactory(() => VerifyPhoneNumberCubit(sl(), sl()));
  sl.registerFactory(() => RegisterUserCubit(sl(), sl(), sl()));
  sl.registerFactory(() => DisplayAllProductsCubit(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => GetPaginatedProductsCubit(sl()));
  sl.registerFactory(
    () => GetFavoriteProductsCubit(
        getFavoriteProducts: sl(),
        getProductById: sl(),
        setFavoriteProducts: sl(),
        networkInfo: sl()),
  );
  sl.registerFactory(() => SetFavoriteProductsCubit(sl()));
  sl.registerFactory(
    () => GetUserAndProductsByUserIdCubit(
      getMyProducts: sl(),
      getUserById: sl(),
      networkInfo: sl(),
      getFavoriteProducts: sl(),
    ),
  );
  sl.registerFactory(() =>
      GetProductsByUserIdCubit(getProductsByUserId: sl(), networkInfo: sl()));
  sl.registerFactory(() => AuthPhoneNumberCubit(sl()));
  sl.registerFactory(() => LogOutCubit(storeUserCredentials: sl()));
  sl.registerFactory(
    () => UpdateProductCubit(
        updateProduct: sl(), uploadPictures: sl(), networkInfo: sl()),
  );
  sl.registerFactory(
    () => GetDataNeededToManagePostCubit(
        getAllCategories: sl(), getAllCities: sl(), networkInfo: sl()),
  );
  sl.registerFactory(() => GetAllConversationsCubit(sl(), sl()));
  sl.registerFactory(() => GetUserByIdCubit(sl()));
  sl.registerFactory(() => AddTextMessageToConversationCubit(sl()));
  sl.registerFactory(() => GetConversationByIdCubit(sl()));
  sl.registerFactory(() => DeleteProductByIdCubit(sl()));
  sl.registerFactory(() => GetAllCategoriesCubit(sl()));
  sl.registerFactory(() => ChangePasswordCubit(sl()));
  sl.registerFactory(() => FilterProductsCubit(sl()));
  sl.registerFactory(() => RefreshProductCubit(sl(), sl()));
  sl.registerFactory(() => ChangeLanguageCubit(sl()));
  sl.registerFactory(() => MarkMessagesAsReadCubit(sl()));
  sl.registerFactory(
    () => GetPostDetailContentCubit(
        getFavoriteProducts: sl(), getUserById: sl(), networkInfo: sl()),
  );
  sl.registerFactory(
    () => HandleGoingToMessageCubit(
      createConversation: sl(),
      getConversationByMembers: sl(),
      getUserById: sl(),
    ),
  );
  sl.registerFactory(
    () => CreateProductCubit(
      createProduct: sl(),
      uploadPictures: sl(),
    ),
  );
  sl.registerFactory(() => GetProductByIdCubit(sl()));
  sl.registerFactory(() => GenerateShareLinkForProductCubit(sl()));
  sl.registerFactory(() => GetProductsByCategoryCubit(sl(), sl()));
  sl.registerFactory(() => SetIsAppOpenedFirstTimeCubit(sl()));
  sl.registerFactory(() => GetIsAppOpenedFirstTimeCubit(sl()));
  sl.registerFactory(() => AddImageMessageToConversationCubit(sl(), sl()));

  // usecases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerLazySingleton(() => VerifyPhoneNumber(sl()));
  sl.registerLazySingleton(() => AuthenticatePhoneNumber(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetPaginatedProducts(sl()));
  sl.registerLazySingleton(() => GetFavoriteProducts(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => SetFavoriteProducts(sl()));
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UploadPictures(sl()));
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
  sl.registerLazySingleton(() => GetProductsByUserId(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => FilterProducts());
  sl.registerLazySingleton(() => GetProductById(sl()));
  sl.registerLazySingleton(() => RefreshProduct(sl()));
  sl.registerLazySingleton(() => MarkMessagesAsRead(sl()));
  sl.registerLazySingleton(() => GenerateShareLinkForProduct(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));
  sl.registerLazySingleton(() => GetIsAppOpenedFirstTime(sl()));
  sl.registerLazySingleton(() => SetIsAppOpenedFirstTime(sl()));

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

  //  Upload Pictures Service

  sl.registerLazySingleton<UploadPicturesService>(
    () => UploadPicturesRepository(sl()),
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
      dynamicLinkDataSource: sl(),
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

  // DYNAMIC LINK SERVICE
  sl.registerLazySingleton<DynamicLinkDataSource>(
    () => FirebaseDynamicLinkDataSource(),
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
