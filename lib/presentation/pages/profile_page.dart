import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SizedBox(
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
                  fontWeight: FontWeight.w700
                ),
              ),
              const Text(
                'adam@gmail.com',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Edit'),
              ),

              const Text('GENERAL')
            ],
          ),
        ),
      ),
    );
  }
}
