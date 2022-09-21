import 'package:flutter/material.dart';

import '../widgets/common/custom_app_bar.dart';

class ContactUsPage extends StatelessWidget {
  static String routeName = "/contactUsPage";
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Contact Us"),
      body: Center(
        child: Text('I am contact us Page'),
      ),
    );
  }
}
