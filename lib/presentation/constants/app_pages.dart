import 'package:flutter/material.dart';
import 'package:mnale_client/presentation/pages/profile_page.dart';

import '../pages/add_post_page.dart';
import '../pages/change_password_page.dart';
import '../pages/chat_detail_page.dart';
import '../pages/chat_list_page.dart';
import '../pages/edit_post_page.dart';
import '../pages/filter_data_page.dart';
import '../pages/forgot_password_page.dart';
import '../pages/home_page.dart';
import '../pages/intro_page.dart';
import '../pages/login_page.dart';
import '../pages/master_page.dart';
import '../pages/my_posts_page.dart';
import '../pages/otp_verification_page.dart';
import '../pages/post_confirmation_page.dart';
import '../pages/post_detail_page.dart';
import '../pages/post_image_screen.dart';
import '../pages/sign_up_page.dart';
import '../pages/splash_page.dart';

class AppPages {
  static Map<String, WidgetBuilder> get() {
    return {
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
      ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
      ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
      PostConfirmationPage.routeName: (context) => const PostConfirmationPage(),
      OtpVerificationPage.routeName: (context) => const OtpVerificationPage(),
      FilterDataPage.routeName: (context) => const FilterDataPage(),
      PostImagesScreen.routeName: (context) => const PostImagesScreen(),
      ProfilePage.routeName: (context) => const ProfilePage(),
    };
  }
}
