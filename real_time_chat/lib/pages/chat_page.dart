import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/models/message.dart';
import 'package:real_time_chat/models/user.dart';
import 'package:real_time_chat/services/auth_services.dart';
import 'package:real_time_chat/services/chat_services.dart';
import 'package:real_time_chat/services/socket_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late TextEditingController _textController;
  late FocusNode _focus;

  late User chatUser;
  late User senderUser;
  late ChatServices chatServices;
  late AuthServices authServices;
  late SocketServices socketServices;

  bool canSend = false;
  List<Message> messages = <Message>[];

  @override
  void initState() {
    _textController = TextEditingController();
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

    chatServices = Provider.of<ChatServices>(context, listen: false);
    authServices = Provider.of<AuthServices>(context, listen: false);
    chatUser = chatServices.toUser!;
    senderUser = authServices.currenUser;

    socketServices = Provider.of<SocketServices>(context, listen: false);
    socketServices.socket.on('send-message', (data) {
      debugPrint('Mensaje nuevo $data');
      final newMessage = Message.fromJson(data);
      newMessage.animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      messages.insert(0, newMessage);
      setState(() {});
      newMessage.animationController?.forward();
    });

    _loadHistorial();

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();

    for (final message in messages) {
      message.animationController?.dispose();
    }
    socketServices.socket.off('send-message');
    super.dispose();
  }

  Future<void> _loadHistorial() async {
    final allMsg = await chatServices.getMessages(chatUser.uid);
    messages = allMsg.map((Message e) {
      e.animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
      debugPrint('Mensaje ${e.message}');

      return e;
    }).toList();
    setState(() {});
  }

  void _handleSubmit() {
    final typedValue = _textController.text.trimLeft().trimRight();
    _focus.requestFocus();

    if (typedValue.isEmpty) {
      return;
    }

    final newMessage = Message(
      from: senderUser.uid,
      to: chatUser.uid,
      message: typedValue,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 500)),
    );
    newMessage.animationController?.forward();

    messages.insert(0, newMessage);
    socketServices.socket.emit('send-message', newMessage.toJson());

    _textController.clear();
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
            CircleAvatar(
              child: Text(chatUser.name.substring(0, 2).toUpperCase()),
              radius: 12,
            ),
            const SizedBox(height: 2),
            Text(
              chatUser.name,
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
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                shrinkWrap: true,
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (_, int index) => MessageBody(
                  message: messages[index],
                  senderUid: senderUser.uid,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
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
    required this.senderUid,
    required this.message,
  }) : super(key: key);

  final String senderUid;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: message.animationController!,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: message.animationController!,
          curve: Curves.elasticInOut,
        ),
        child: Align(
          alignment: message.from == senderUid ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: size.width * .8,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: message.from == senderUid ? Colors.white : Colors.blue,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              crossAxisAlignment: message.from == senderUid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  textAlign: message.from == senderUid ? TextAlign.end : TextAlign.start,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: message.from == senderUid ? Colors.blue : Colors.white,
                      ),
                ),
                Text(
                  message.createdAt.toString(),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        color: message.from == senderUid ? Colors.blue : Colors.white,
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
