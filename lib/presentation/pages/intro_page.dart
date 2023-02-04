import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/intro/intro_page_progress_indicator_bubble.dart';
import 'login_page.dart';

class IntroPage extends StatefulWidget {
  static String routeName = "/introPage";
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int currentInformationIndex = 0;
  dynamic introData = [];

  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  void initData() {
    setState(() {
      introData = [
        {
          'image': "assets/1.png",
          'header': AppLocalizations.of(context).introPageHeaderOne,
          'description': AppLocalizations.of(context).introPageDescriptionOne
        },
        {
          'image': "assets/2.png",
          'header': AppLocalizations.of(context).introPageHeaderTwo,
          'description': AppLocalizations.of(context).introPageDescriptionTwo
        },
        {
          'image': "assets/3.png",
          'header': AppLocalizations.of(context).introPageHeaderThree,
          'description': AppLocalizations.of(context).introPageDescriptionThree
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  renderSkipButton(),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 600,
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (value) {
                        setState(() {
                          currentInformationIndex = value;
                        });
                      },
                      children: [
                        renderMainContent(),
                        renderMainContent(),
                        renderMainContent(),
                      ],
                    ),
                  ),
                  renderProgressIndicatorBubbles(),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentInformationIndex < introData.length - 1) {
                          setState(() {
                            currentInformationIndex++;
                          });
                          _controller.animateToPage(
                            currentInformationIndex,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.bounceInOut,
                          );
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            LoginPage.routeName,
                          );
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context).introPageNextButtonText,
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
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column renderMainContent() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 301,
          child: Image.asset(
            introData.elementAt(currentInformationIndex)["image"]!,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          introData.elementAt(currentInformationIndex)["header"]!,
          style: const TextStyle(
            color: Color(0xff1B1D21),
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          introData.elementAt(currentInformationIndex)["description"]!,
          style: const TextStyle(
            height: 1.5,
            color: Colors.grey,
            fontSize: 16,
            letterSpacing: 0.36,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  SizedBox renderProgressIndicatorBubbles() {
    return SizedBox(
      width: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntroPageProgressIndicatorBubble(
            isActive: currentInformationIndex == 0,
          ),
          IntroPageProgressIndicatorBubble(
            isActive: currentInformationIndex == 1,
          ),
          IntroPageProgressIndicatorBubble(
            isActive: currentInformationIndex == 2,
          ),
        ],
      ),
    );
  }

  GestureDetector renderSkipButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      },
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 41,
          width: 69,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF11435E),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context).introPageSkipButtonText,
              style: const TextStyle(
                color: Color(0xFF11435E),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
