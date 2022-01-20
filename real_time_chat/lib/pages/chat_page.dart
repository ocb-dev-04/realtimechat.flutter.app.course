import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _textController;
  late FocusNode _focus;

  bool canSend = false;

  void _handleSubmit(String submmit) {
    // final typedValue = _textController.text;
    if (submmit.isEmpty) {
      _focus.requestFocus();
      return;
    }

    debugPrint(submmit);
    _textController.clear();
    _focus.requestFocus();
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.addListener(() {
      final text = _textController.text;
      if (text.isEmpty) {
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
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 100,
              reverse: true,
              itemBuilder: (_, int index) {
                return Text(index.toString());
              },
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focus,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type something...',
                      ),
                      onSubmitted: _handleSubmit,
                      onChanged: (String vale) {
                        // TODO: to set socket value in typing...
                      },
                    ),
                  ),
                  !Platform.isIOS
                      ? CupertinoButton(
                          child: const Text('Send'),
                          disabledColor: Colors.grey,
                          onPressed: canSend
                              ? () {
                                  print('Sending...');
                                }
                              : null,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send,
                            color: canSend ? Colors.blue : Colors.grey,
                          ),
                          disabledColor: Colors.grey,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: canSend
                              ? () {
                                  print('Sending...');
                                }
                              : null,
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
