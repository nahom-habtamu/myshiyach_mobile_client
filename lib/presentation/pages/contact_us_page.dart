import 'package:flutter/material.dart';
import 'package:mnale_client/presentation/widgets/common/curved_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/common/custom_app_bar.dart';
import '../widgets/post_detail/detail_item.dart';

class ContactUsPage extends StatelessWidget {
  static String routeName = "/contactUsPage";
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: const CustomAppBar(title: "Contact Us"),
      body: CurvedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: renderContent(context),
        ),
      ),
    );
  }

  SingleChildScrollView renderContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Column(
                  children: [
                    DetailItem(
                      title: const Text('PhoneNumber'),
                      subtitle: const Text('8090'),
                      onClick: () async {
                        const _call = 'tel:8090';
                        if (await canLaunchUrl(Uri.parse(_call))) {
                          await launchUrl(Uri.parse(_call));
                        }
                      },
                    ),
                    DetailItem(
                      title: const Text('Email'),
                      subtitle: const Text('someemail@gmail.com'),
                      onClick: () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'someemail@gmail.com',
                        );
                        launchUrl(emailLaunchUri);
                      },
                    ),
                  ],
                ),
                const DetailItem(
                  title: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      'About Our Company',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
                    ),
                  ),
                ),
                const DetailItem(
                  title: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      'About Our Product',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Developers',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          const _call = 'tel:+251926849888';
                          if (await canLaunchUrl(Uri.parse(_call))) {
                            await launchUrl(Uri.parse(_call));
                          }
                        },
                        child: const ListTile(
                          title: Text('Nahom Habtamu'),
                          leading: CircleAvatar(
                            radius: 30,
                            child: Text('N'),
                          ),
                          subtitle: Text('Phone Number - +251926849888'),
                          trailing: Icon(Icons.phone),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          const _call = 'tel:+251926849888';
                          if (await canLaunchUrl(Uri.parse(_call))) {
                            await launchUrl(Uri.parse(_call));
                          }
                        },
                        child: const ListTile(
                          title: Text('Natnael Masresha'),
                          leading: CircleAvatar(
                            radius: 30,
                            child: Text('N'),
                          ),
                          subtitle: Text('Phone Number - +251926849888'),
                          trailing: Icon(Icons.phone),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          const _call = 'tel:+251926849888';
                          if (await canLaunchUrl(Uri.parse(_call))) {
                            await launchUrl(Uri.parse(_call));
                          }
                        },
                        child: const ListTile(
                          title: Text('Yonathan Zelalem'),
                          leading: CircleAvatar(
                            radius: 30,
                            child: Text('Y'),
                          ),
                          subtitle: Text('Phone Number - +251926849888'),
                          trailing: Icon(Icons.phone),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
