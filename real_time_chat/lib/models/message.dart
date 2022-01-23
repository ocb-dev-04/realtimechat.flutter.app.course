import 'package:flutter/animation.dart';

class Message {
  final String uid;
  final String text;
  final int timeStamp;
  final AnimationController controller;

  Message({
    required this.uid,
    required this.text,
    required this.timeStamp,
    required this.controller,
  });
}
