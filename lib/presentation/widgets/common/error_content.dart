import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'empty_state_content.dart';

class ErrorContent extends StatelessWidget {
  final Function onButtonClicked;
  const ErrorContent({
    Key? key,
    required this.onButtonClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FallBackContent(
      captionText: AppLocalizations.of(context).commonFallBackErrorCaptionText,
      onButtonClicked: () {
        onButtonClicked();
      },
      hintText: AppLocalizations.of(context).commonFallBackErrorHintText,
      buttonText: AppLocalizations.of(context).commonFallBackErrorButtonText,
    );
  }
}
