import 'package:flutter/material.dart';

import 'home_page.dart';

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
        body: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.teal,
                radius: 50,
              ),
              SizedBox(
                height: 300,
                child: Column(
                  children: const [
                    Text(
                      'Ad Placed',
                      style: TextStyle(
                        color: Color(0xff11435E),
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Your ad has been Successfully placed, Our logistic team will contact with you soon.For any help, call (+251) 12345678',
                      style: TextStyle(
                        color: Color(0xff11435E),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, HomePage.routeName);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
