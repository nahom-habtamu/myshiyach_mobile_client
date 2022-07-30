import 'package:flutter/material.dart';

import 'master_page.dart';

class OfflinePage extends StatelessWidget {
  static String routeName = '/offlinePage';
  const OfflinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 45,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 301,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25),
                  ),
                  child: Image.asset(
                    'assets/no_network.jpg',
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: const Text(
                  'Please Connect to the internet to continue using the application',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(MasterPage.routeName);
                    },
                    child: const Text(
                      'Retry',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xff11435E),
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      primary: const Color(0xff11435E),
                      textStyle: const TextStyle(
                        color: Color(0xff11435E),
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
