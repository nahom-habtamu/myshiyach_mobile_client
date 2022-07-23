import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showActions;
  final Function(String) onAppBarMenuClicked;
  final bool isFavorite;
  const PostDetailAppBar({
    Key? key,
    this.showActions = false,
    required this.onAppBarMenuClicked,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context).forgotPassowordHeaderOne,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xff11435E),
      elevation: 0,
      centerTitle: true,
      actions: [
        Visibility(
          visible: showActions,
          child: PopupMenuButton<String>(
            onSelected: (value) => onAppBarMenuClicked(value),
            itemBuilder: (BuildContext context) {
              var contentToShowOnPopup = isFavorite
                  ? {
                      AppLocalizations.of(context).postDetailEditText,
                      AppLocalizations.of(context).postDetailRefreshText,
                      AppLocalizations.of(context).postDetailSaveText,
                    }
                  : {
                      AppLocalizations.of(context).postDetailEditText,
                      AppLocalizations.of(context).postDetailRefreshText,
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
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 60);
}
