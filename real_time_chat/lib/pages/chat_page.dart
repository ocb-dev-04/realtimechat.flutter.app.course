import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late TextEditingController _textController;
  late AnimationController animationController;
  late FocusNode _focus;

  bool canSend = false;
  final messages = <Message>[];

  void _handleSubmit() {
    final typedValue = _textController.text.trimLeft().trimRight();
    _focus.requestFocus();

    if (typedValue.isEmpty) {
      return;
    }

    final newMessage = Message(
      uid: '123',
      text: typedValue,
      sender: 'Oscar Ch. B',
      timeStamp: DateTime.now().toIso8601String(),
      controller: animationController,
    );
    newMessage.controller.forward();

    messages.insert(0, newMessage);
    _textController.clear();
  }

  @override
  void initState() {
    _textController = TextEditingController();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _textController.addListener(() {
      final text = _textController.text;
      if (text.trimLeft().trimRight().isEmpty) {
        canSend = false;
        setState(() {});
      } else {
        canSend = true;
        setState(() {});
      }
    });
    _focus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: <Widget>[
            const CircleAvatar(
              child: Text('IN'),
              radius: 12,
            ),
            const SizedBox(height: 2),
            Text(
              'Nombre de usuario',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (_, int index) {
                  return MessageBody(message: messages[index]);
                },
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focus,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type something...',
                      ),
                      onSubmitted: (String value) => _handleSubmit(),
                    ),
                  ),
                  Platform.isIOS
                      ? CupertinoButton(
                          child: const Text('Send'),
                          disabledColor: Colors.grey,
                          onPressed: canSend ? () => _handleSubmit() : null,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send,
                            color: canSend ? Colors.blue : Colors.grey,
                          ),
                          disabledColor: Colors.grey,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: canSend ? () => _handleSubmit() : null,
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageBody extends StatelessWidget {
  const MessageBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: message.controller,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: message.controller,
          curve: Curves.elasticInOut,
        ),
        child: Align(
          alignment: message.uid == '123' ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: size.width * .8,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: message.uid == '123' ? Colors.white : Colors.blue,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: message.uid == '123' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: message.uid == '123' ? Colors.blue : Colors.white,
                      ),
                ),
                Text(
                  message.timeStamp,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: message.uid == '123' ? Colors.blue : Colors.white,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
