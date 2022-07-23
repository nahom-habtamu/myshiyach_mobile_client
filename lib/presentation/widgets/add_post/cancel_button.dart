import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'change_input_state_button.dart';

class CancelButton extends StatelessWidget {
  final Function onTap;
  const CancelButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeInputButton(
      text: AppLocalizations.of(context).addPostButtonCancelText,
      onTap: () {
        onTap();
      },
    );
  }
}
