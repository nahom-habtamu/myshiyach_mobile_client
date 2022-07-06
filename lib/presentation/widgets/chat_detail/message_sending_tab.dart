import 'package:flutter/material.dart';

import '../../constants/login_page_constants.dart';

class MessageSendingTab extends StatefulWidget {
  final Function(String) onMessageChanged;
  final Function onMessageSend;
  const MessageSendingTab({
    Key? key,
    required this.onMessageChanged,
    required this.onMessageSend,
  }) : super(key: key);

  @override
  State<MessageSendingTab> createState() => _MessageSendingTabState();
}

class _MessageSendingTabState extends State<MessageSendingTab> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                style: loginInputTextStyle.copyWith(fontSize: 14),
                controller: _controller,
                onChanged: (value) => widget.onMessageChanged(value),
                decoration: const InputDecoration(
                  labelText: "Enter Message",
                  border: loginInputEnabledBorder,
                  enabledBorder: loginInputEnabledBorder,
                  focusedBorder: loginInputDisabledBorder,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                ),
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
            ),
            IconButton(
              onPressed: () {
                _controller.clear();
                widget.onMessageSend();
              },
              icon: const Icon(
                Icons.send,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
