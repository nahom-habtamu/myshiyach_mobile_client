import 'package:flutter/material.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../domain/enitites/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final String strangerId;
  final bool isSentByCurrentUser;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.strangerId,
    required this.isSentByCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByCurrentUser
          ? FractionalOffset.centerLeft
          : FractionalOffset.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Stack(
          children: [
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: message.senderId == strangerId
                    ? const Color(0xff11435E)
                    : Colors.black12,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(25),
                  topRight: const Radius.circular(25),
                  bottomLeft: message.senderId == strangerId
                      ? const Radius.circular(25)
                      : Radius.zero,
                  bottomRight: message.senderId != strangerId
                      ? const Radius.circular(15)
                      : Radius.zero,
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
              child: Center(
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: message.senderId == strangerId
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: 3,
              right: 13,
              child: Text(
                DateFormatterUtil.extractTimeFromDate(message.createdDateTime),
                style: TextStyle(
                  color: message.senderId == strangerId
                      ? Colors.white
                      : Colors.black,
                  fontSize: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
