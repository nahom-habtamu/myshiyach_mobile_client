import 'package:flutter/material.dart';

import 'master_page.dart';

class PostConfirmationPage extends StatelessWidget {
  static String routeName = '/postConfirmationPage';
  const PostConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF1F1F1),
        appBar: AppBar(
          title: const Text(
            'Post Information',
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
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: Column(
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
            ),
          ),
        ),
      ),
    );
  }
}
