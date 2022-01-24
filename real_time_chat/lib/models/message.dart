// To parse this JSON data, do
//
//     final messagesResponseModel = messagesResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/animation.dart';

MessagesResponseModel messagesResponseModelFromJson(String str) => MessagesResponseModel.fromJson(json.decode(str));

String messagesResponseModelToJson(MessagesResponseModel data) => json.encode(data.toJson());

class MessagesResponseModel {
  MessagesResponseModel({
    required this.ok,
    required this.messages,
  });

  bool ok;
  List<Message> messages;

  factory MessagesResponseModel.fromJson(Map<String, dynamic> json) => MessagesResponseModel(
        ok: json["ok"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.message,
    required this.from,
    required this.to,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.animationController,
  });

  String message;
  String from;
  String to;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;
  AnimationController? animationController;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        message: json["message"],
        from: json["from"],
        to: json["to"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "from": from,
        "to": to,
        "id": id,
      };
}
