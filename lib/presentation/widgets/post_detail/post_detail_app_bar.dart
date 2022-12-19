import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showActions;
  final Function(String) onAppBarMenuClicked;
  const PostDetailAppBar({
    Key? key,
    this.showActions = false,
    required this.onAppBarMenuClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).postDetailAppBarText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xff11435E),
      elevation: 0,
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) => onAppBarMenuClicked(value),
          itemBuilder: (BuildContext context) {
            var contentToShowOnPopup = showActions
                ? {
                    AppLocalizations.of(context).postDetailEditText,
                    AppLocalizations.of(context).postDetailDeleteText,
                    AppLocalizations.of(context).postDetailRefreshText,
                    AppLocalizations.of(context).postDetailShareText,
                  }
                : {
                    AppLocalizations.of(context).postDetailShareText,
                    AppLocalizations.of(context).postDetailReportText,
                  };
            return contentToShowOnPopup.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList();
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 45);
}
