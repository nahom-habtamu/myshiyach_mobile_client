import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

import '../widgets/common/curved_container.dart';
import '../widgets/common/custom_app_bar.dart';

class TermsAndServicesPage extends StatefulWidget {
  static String routeName = "/termsAndServicesPage";
  const TermsAndServicesPage({Key? key}) : super(key: key);

  @override
  State<TermsAndServicesPage> createState() => _TermsAndServicesPageState();
}

class _TermsAndServicesPageState extends State<TermsAndServicesPage> {
  static final facebookAppEvents = FacebookAppEvents();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    facebookAppEvents.logEvent(
      name: 'privacy_page_opened',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff11435E),
      appBar: CustomAppBar(title: 'Terms and Services'),
      body: CurvedContainer(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
        child: WebView(
          initialUrl: 'http://167.172.148.80:9050/',
        ),
      ),
    );
  }
}
