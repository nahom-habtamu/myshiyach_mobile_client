import 'package:flutter/material.dart';

import '../../../domain/enitites/user.dart';
import '../../pages/posts_created_by_user_page.dart';

class StrangerUserInfo extends StatelessWidget {
  final User strangerUser;
  const StrangerUserInfo({
    Key? key,
    required this.strangerUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var splittedStrangerName = strangerUser.fullName.split(" ");
    var avatarContent = splittedStrangerName.first[0].toUpperCase() +
        splittedStrangerName.last[0].toUpperCase();
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          PostsCreatedByUserPage.routeName,
          arguments: strangerUser.id,
        );
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 15,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              width: 60,
              height: 60,
              child: Center(
                child: Text(
                  avatarContent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strangerUser.fullName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  strangerUser.email ?? "no email",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
