import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mnale_client/presentation/pages/my_posts_page.dart';

import 'core/services/injection_container.dart' as di;
import 'core/services/injection_container.dart';
import 'presentation/bloc/add_message_to_conversation/add_message_to_conversation_cubit.dart';
import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/create_conversation/handle_going_to_message_cubit.dart';
import 'presentation/bloc/create_product/create_product_cubit.dart';
import 'presentation/bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import 'presentation/bloc/display_all_products/display_all_products_cubit.dart';
import 'presentation/bloc/get_all_categories/get_all_categories_cubit.dart';
import 'presentation/bloc/get_all_conversations/get_all_conversations_cubit.dart';
import 'presentation/bloc/get_all_products/get_all_products_cubit.dart';
import 'presentation/bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import 'presentation/bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import 'presentation/bloc/get_favorite_products/get_favorite_products_cubit.dart';
import 'presentation/bloc/get_my_products/get_my_products_cubit.dart';
import 'presentation/bloc/get_user_by_id/get_user_by_id_cubit.dart';
import 'presentation/bloc/logout/logout_cubit.dart';
import 'presentation/bloc/register_user/register_user_cubit.dart';
import 'presentation/bloc/set_favorite_products/set_favorite_products_cubit.dart';
import 'presentation/bloc/update_product/update_product_cubit.dart';
import 'presentation/bloc/verify_phone_number/verify_phone_number_cubit.dart';
import 'presentation/pages/add_post_page.dart';
import 'presentation/pages/chat_detail_page.dart';
import 'presentation/pages/chat_list_page.dart';
import 'presentation/pages/edit_post_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/intro_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/master_page.dart';
import 'presentation/pages/otp_verification_page.dart';
import 'presentation/pages/post_confirmation_page.dart';
import 'presentation/pages/post_detail_page.dart';
import 'presentation/pages/sign_up_page.dart';
import 'presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<VerifyPhoneNumberCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<RegisterUserCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<DisplayAllProductsCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetAllProductsCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetFavoriteProductsCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<SetFavoriteProductsCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetDataNeededToManagePostCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<CreateProductCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetAllConversationsCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetConversationByIdCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetUserByIdCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<AddMessageToConversationCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<DeleteProductByIdCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<HandleGoingToMessageCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetAllCategoriesCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<UpdateProductCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<LogOutCubit>(),
        ),
        BlocProvider(
          create: (_) => sl<GetMyProductsCubit>(),
        )
      ],
      child: MaterialApp(
        title: 'Mnale',
        theme: ThemeData(
          primaryColor: const Color(0xff11435E),
          fontFamily: 'DMSans',
        ),
        home: const SplashPage(),
        routes: {
          SplashPage.routeName: (context) => const SplashPage(),
          HomePage.routeName: (context) => const HomePage(),
          IntroPage.routeName: (context) => const IntroPage(),
          LoginPage.routeName: (context) => const LoginPage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
          MasterPage.routeName: (context) => const MasterPage(),
          PostDetailPage.routeName: (context) => const PostDetailPage(),
          AddPostPage.routeName: (context) => const AddPostPage(),
          ChatListPage.routeName: (context) => const ChatListPage(),
          ChatDetailPage.routeName: (context) => const ChatDetailPage(),
          EditPostPage.routeName: (context) => const EditPostPage(),
          MyPostsPage.routeName: (context) => const MyPostsPage(),
          PostConfirmationPage.routeName: (context) =>
              const PostConfirmationPage(),
          OtpVerificationPage.routeName: (context) =>
              const OtpVerificationPage(),
        },
      ),
    );
  }
}
