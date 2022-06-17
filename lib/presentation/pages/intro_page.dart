import 'package:flutter/material.dart';

import 'login_page.dart';

class IntroPage extends StatefulWidget {
  static String routeName = "/introPage";
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int currentInformationIndex = 0;

  var introData = [
    {
      'image':
          "https://cdn2.iconfinder.com/data/icons/customer-support-38/200/asking-question-3--ask-question-MARK-CUSTOMER-SERVICE-SUPPORT-ASSISTANCE-MAN-SHRUG-HELP-512.png",
      'header': "Easy Process",
      'description':
          'Find all your needs in one place.  We provide every service to make your experience smooth.'
    },
    {
      'image':
          "https://cdn2.iconfinder.com/data/icons/customer-support-38/200/asking-question-4--ask-question-MARK-CUSTOMER-SERVICE-SUPPORT-ASSISTANCE-MAN-HELP-THINKING-CONFUSED-512.png",
      'header': "Expert People",
      'description':
          'We have the best in class individuals working just for you. They are well  trained and capable of handling anything you need.'
    },
    {
      'image':
          "https://thumbs.dreamstime.com/z/mark-question-shine-asking-questions-ask-help-shining-question-mark-stamp-need-information-stock-vector-mark-168461097.jpg",
      'header': "Some Way",
      'description':
          'You will get what you need , therefore you will be satisfied'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                  width: MediaQuery.of(context).size.width,
                  height: 301,
                  child: Image.network(
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
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginPage.routeName,
                        );
                      }
                    },
                    child: const Text('Next'),
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
          child: const Center(
            child: Text(
              'Skip',
              style: TextStyle(
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

class IntroPageProgressIndicatorBubble extends StatelessWidget {
  final bool isActive;
  const IntroPageProgressIndicatorBubble({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: !isActive ? 9 : 28,
      height: 9,
      decoration: BoxDecoration(
        color: !isActive ? Colors.grey : const Color(0xFF11435E),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
