import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/enitites/user.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/change_language/change_language_cubit.dart';
import '../bloc/logout/logout_cubit.dart';
import '../bloc/logout/logout_state.dart';
import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/pop_up_dialog.dart';
import '../widgets/profile/setting_item.dart';
import '../widgets/profile/settings_item_header.dart';
import 'contact_us_page.dart';
import 'login_page.dart';
import 'my_posts_page.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/profilePage';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    context.read<LogOutCubit>().clear();
    var authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccessfull) {
      currentUser = authState.currentUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).profilePageAppBarText,
      ),
      body: CurvedContainer(
        child: SingleChildScrollView(
          child: renderContent(),
        ),
      ),
    );
  }

  Column renderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        CircleAvatar(
          radius: 50,
          child: Center(
            child: Text(
              currentUser!.fullName[0],
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          currentUser!.fullName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: currentUser?.email != null && currentUser!.email!.isNotEmpty,
          child: Text(
            currentUser?.email ?? "",
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
        const Divider(),
        SettingsItemHeader(
          content: AppLocalizations.of(context).profilePageGeneralHeaderText,
        ),
        const SizedBox(
          height: 15,
        ),
        SettingItem(
          leadingIcon: Icons.my_library_add,
          title: AppLocalizations.of(context).profilePageMyPostsTitle,
          subTitle: AppLocalizations.of(context).profilePageMyPostsSubTitle,
          onPressed: () {
            Navigator.pushNamed(
              context,
              MyPostsPage.routeName,
            );
          },
        ),
        const SizedBox(
          height: 25,
        ),
        SettingsItemHeader(
          content: AppLocalizations.of(context).profilePageMoreHeaderText,
        ),
        const SizedBox(
          height: 15,
        ),
        SettingItem(
          title: AppLocalizations.of(context).profilePageContactTitle,
          subTitle: AppLocalizations.of(context).profilePageContactSubTitle,
          leadingIcon: Icons.call,
          onPressed: () =>
              Navigator.pushNamed(context, ContactUsPage.routeName),
        ),
        BlocBuilder<ChangeLanguageCubit, String>(
          builder: (context, state) {
            return SettingItem(
              title: AppLocalizations.of(context).profilePageLanguageTitle,
              subTitle:
                  AppLocalizations.of(context).profilePageLanguageSubTitle,
              leadingIcon: Icons.language,
              trailingIconType: "SWITCH",
              value: state == "am",
              onValueChanged: (value) {
                if (value) {
                  context.read<ChangeLanguageCubit>().call("am");
                } else {
                  context.read<ChangeLanguageCubit>().call("en");
                }
              },
            );
          },
        ),
        BlocBuilder<LogOutCubit, LogOutState>(
          builder: (context, state) {
            if (state is LogOutSuccessfull) {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(
                  context,
                  LoginPage.routeName,
                );
              });
            } else if (state is LogOutLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SettingItem(
              title: AppLocalizations.of(context).profilePageLogoutHeader,
              leadingIcon: Icons.exit_to_app,
              onPressed: () async {
                var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PopupDialog(
                      content:
                          AppLocalizations.of(context).profileLogoutPopUpHeader,
                    );
                  },
                );
                if (result) context.read<LogOutCubit>().call();
              },
            );
          },
        ),
      ],
    );
  }
}
