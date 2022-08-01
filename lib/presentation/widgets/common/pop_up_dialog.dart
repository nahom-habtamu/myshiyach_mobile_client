import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PopupDialog extends StatelessWidget {
  final String content;
  const PopupDialog({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).popUpDialogTitle,
      ),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            AppLocalizations.of(context).popUpDialogConfirmButtonText,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            AppLocalizations.of(context).popUpDialogCancelButtonText,
          ),
        ),
      ],
    );
  }
}
