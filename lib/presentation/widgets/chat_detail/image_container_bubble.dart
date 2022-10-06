import 'package:flutter/material.dart';

import '../../../core/utils/date_time_formatter.dart';
import '../../../domain/enitites/message.dart';

class ImageMessageContainer extends StatelessWidget {
  final Message message;
  final String strangerId;
  final bool isSentByCurrentUser;
  const ImageMessageContainer({
    Key? key,
    required this.message,
    required this.strangerId,
    required this.isSentByCurrentUser,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: isSentByCurrentUser
              ? FractionalOffset.centerLeft
              : FractionalOffset.centerRight,
          child: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 300,
                child: Image.network(
                  message.content,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Container(
                  color: const Color(0xFF363535),
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    DateFormatterUtil.extractTimeFromDate(
                        message.createdDateTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
