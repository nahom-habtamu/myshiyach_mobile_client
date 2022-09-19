import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';
import 'master_page.dart';

class PostConfirmationPage extends StatelessWidget {
  static String routeName = '/postConfirmationPage';
  const PostConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff11435E),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).postConfirmationAppBarText,
      ),
      body: CurvedContainer(
        child: renderContent(context),
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
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                AppLocalizations.of(context).postConfirmationAdPlaced,
                style: const TextStyle(
                  color: Color(0xff11435E),
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                AppLocalizations.of(context)
                    .postConfirmationAdPlacedSuccessfull,
                style: const TextStyle(
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
              child: Text(
                AppLocalizations.of(context)
                    .postConfirmationGoToHomePageButtonText,
              ),
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
