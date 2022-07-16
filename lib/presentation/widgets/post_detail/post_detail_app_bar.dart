import 'package:flutter/material.dart';

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
      title: const Text(
        'Post Detail',
        style: TextStyle(
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
                  ? {'Edit', 'Refresh', "Save"}
                  : {
                      'Edit',
                      'Refresh',
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
