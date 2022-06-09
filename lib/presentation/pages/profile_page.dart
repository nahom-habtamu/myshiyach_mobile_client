import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/logout/logout_cubit.dart';
import '../bloc/logout/logout_state.dart';
import '../widgets/profile/setting_item.dart';
import '../widgets/profile/settings_item_header.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color(0xffF1F1F1),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(top: 25),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Adam Turin',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'adam@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Edit'),
                ),
                const SizedBox(
                  height: 35,
                ),
                const SettingsItemHeader(content: "General"),
                const SizedBox(
                  height: 15,
                ),
                const SettingItem(
                  leadingIcon: Icons.payment,
                  subTitle: "Add your credit & debit cards",
                  title: "Payment Methods",
                ),
                const SettingItem(
                  title: "Locations",
                  subTitle: "Add your home & work  locations",
                  leadingIcon: Icons.location_on,
                ),
                const SettingItem(
                  title: "Add Social Account",
                  subTitle: "Add Facebook, Instagram, Twitter etc ",
                  leadingIcon: Icons.camera_alt,
                ),
                const SettingItem(
                  title: "Refer to Friends",
                  subTitle: "Refer to friends for a chance of winning",
                  leadingIcon: Icons.share,
                ),
                const SizedBox(
                  height: 25,
                ),
                const SettingsItemHeader(content: "Notifications"),
                const SizedBox(
                  height: 15,
                ),
                const SettingItem(
                  title: "Push Notifications",
                  subTitle: "For daily update and others.",
                  leadingIcon: Icons.notifications,
                  trailingIconType: "SWITCH",
                ),
                const SettingItem(
                  title: "Promotional Notifications",
                  subTitle: "New Campaign & Offers",
                  leadingIcon: Icons.notifications,
                  trailingIconType: "SWITCH",
                ),
                const SizedBox(
                  height: 25,
                ),
                const SettingsItemHeader(content: "More"),
                const SizedBox(
                  height: 15,
                ),
                const SettingItem(
                  title: "Contact Us",
                  subTitle: "For More Information",
                  leadingIcon: Icons.call,
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
                      title: "Logout",
                      leadingIcon: Icons.exit_to_app,
                      onPressed: () {
                        context.read<LogOutCubit>().call();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
