import 'package:flutter/material.dart';

import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import 'master_page.dart';

class PostConfirmationPage extends StatelessWidget {
  static String routeName = '/postConfirmationPage';
  const PostConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff11435E),
        appBar: const CustomAppBar(title: "Post Confirmation"),
        body: CurvedContainer(
          child: renderContent(context),
        ),
      ),
    );
  }

  Column renderContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.transparent,
          child: Image.asset(
            'assets/success.png',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          child: Column(
            children: const [
              SizedBox(
                height: 15,
              ),
              Text(
                'Ad Placed',
                style: TextStyle(
                  color: Color(0xff11435E),
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Your ad has been Successfully placed, Our logistic team will contact with you soon. For any help, call (+251) 12345678',
                style: TextStyle(
                  color: Color(0xff11435E),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  MasterPage.routeName,
                );
              },
              child: const Text('Go to Homepage'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff11435E),
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
