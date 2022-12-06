import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      appBar:
          CustomAppBar(title: AppLocalizations.of(context).contactUsAppBarText),
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
                          children: [
                            const Icon(
                              Icons.phone,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(AppLocalizations.of(context)
                                .contactUsCallUsText),
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
                          children: [
                            const Icon(
                              Icons.email,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(AppLocalizations.of(context)
                                .contactUsEmailUsText),
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
                DetailItem(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      AppLocalizations.of(context).contactUsAboutOurCompanyText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .contactUsAboutOurCompanyValue,
                    ),
                  ),
                ),
                DetailItem(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      AppLocalizations.of(context).contactUsAboutOurProductText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      AppLocalizations.of(context)
                          .contactUsAboutOurProductValue,
                    ),
                  ),
                ),
                DetailItem(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context).contactUsAddressText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                              AppLocalizations.of(context).contactUsCityText),
                          subtitle: Text(AppLocalizations.of(context)
                              .contactUsCityValueText),
                        ),
                        const Divider(),
                        ListTile(
                          title: Text(AppLocalizations.of(context)
                              .contactUsAddressLineText),
                          subtitle: Text(AppLocalizations.of(context)
                              .contactUsAddressLineValueText),
                        ),
                        const Divider(),
                        ListTile(
                          title: Text(AppLocalizations.of(context)
                              .contactUsSpecificAddressText),
                          subtitle: Text(AppLocalizations.of(context)
                              .contactUsSpecificAddressValueText),
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
