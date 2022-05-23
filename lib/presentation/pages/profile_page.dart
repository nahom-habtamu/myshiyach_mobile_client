import 'package:flutter/material.dart';

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
                const SettingItem(
                  title: "Logout",
                  leadingIcon: Icons.exit_to_app,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsItemHeader extends StatelessWidget {
  final String content;
  const SettingsItemHeader({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          content.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.9,
          ),
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData leadingIcon;
  final String trailingIconType;

  const SettingItem({
    Key? key,
    required this.title,
    this.subTitle = "",
    required this.leadingIcon,
    this.trailingIconType = "ARROW",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xff1B1D21),
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: 0.28,
          ),
        ),
        subtitle: subTitle.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  subTitle,
                  style: const TextStyle(
                    color: Color(0x82000000),
                    fontSize: 14,
                    letterSpacing: 0.28,
                  ),
                ),
              )
            : Container(),
        trailing: trailingIconType == "ARROW"
            ? const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff1B1D21),
                size: 18,
              )
            : Switch(
                value: true,
                onChanged: (value) {},
              ),
        leading: Icon(leadingIcon),
        onTap: () {},
      ),
    );
  }
}
