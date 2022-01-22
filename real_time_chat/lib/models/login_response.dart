import 'dart:convert';

import 'package:real_time_chat/models/user.dart';

class LoginResponseModel {
  LoginResponseModel({
    required this.ok,
    required this.user,
    required this.token,
  });

  final bool ok;
  final User user;
  final String token;

  factory LoginResponseModel.fromRawJson(String str) => LoginResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        ok: json["ok"],
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "user": user.toJson(),
        "token": token,
      };
}
