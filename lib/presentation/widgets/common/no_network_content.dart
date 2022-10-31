import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'empty_state_content.dart';

class NoNetworkContent extends StatelessWidget {
  final Function onButtonClicked;
  const NoNetworkContent({
    Key? key,
    required this.onButtonClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FallBackContent(
      captionText:
          AppLocalizations.of(context).commonFallBackNoNetworkCaptionText,
      onButtonClicked: () {
        onButtonClicked();
      },
      hintText: AppLocalizations.of(context).commonFallBackNoNetworkButtonText,
      buttonText: AppLocalizations.of(context).commonFallBackNoNetworkHintText,
    );
  }
}
