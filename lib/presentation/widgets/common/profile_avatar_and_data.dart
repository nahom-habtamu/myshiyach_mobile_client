import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/enitites/user.dart';

class ProfileAvatarAndData extends StatelessWidget {
  const ProfileAvatarAndData({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        CircleAvatar(
          backgroundColor: const Color(0xff11435E),
          radius: 50,
          child: Center(
            child: Text(
              user!.fullName[0],
              style: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          user!.fullName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            final _call = 'tel:${user!.phoneNumber}';
            if (await canLaunchUrl(Uri.parse(_call))) {
              await launchUrl(Uri.parse(_call));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D1D1)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 30,
              ),
              child: Text(
                user!.phoneNumber,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: user?.email != null && user!.email!.isNotEmpty,
          child: GestureDetector(
            onTap: () async {
              final _call = 'mailto:${user!.email}';
              if (await canLaunchUrl(Uri.parse(_call))) {
                await launchUrl(Uri.parse(_call));
              }
            },
            child: Text(
              user?.email ?? "",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
