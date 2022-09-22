import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/common/curved_container.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: DetailItem(
                        isCurved: true,
                        title: Row(
                          children: const [
                            Icon(
                              Icons.phone,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Call Us'),
                          ],
                        ),
                        subtitle: const Text('091111222211'),
                        onClick: () async {
                          const _call = 'tel:091111222211';
                          if (await canLaunchUrl(Uri.parse(_call))) {
                            await launchUrl(Uri.parse(_call));
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: DetailItem(
                        isCurved: true,
                        title: Row(
                          children: const [
                            Icon(
                              Icons.email,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Email Us'),
                          ],
                        ),
                        subtitle: const Text('someemail@gmail.com'),
                        onClick: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'someemail@gmail.com',
                          );
                          launchUrl(emailLaunchUri);
                        },
                      ),
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
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                DetailItem(
                  title: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Address',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Column(
                      children: const [
                        ListTile(
                          title: Text('City'),
                          subtitle: Text('Addis Ababa'),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Address Line'),
                          subtitle: Text('Bole Rwanda'),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Specific Address'),
                          subtitle: Text(
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the'),
                        )
                      ],
                    ),
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
