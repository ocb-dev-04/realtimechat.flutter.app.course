import 'dart:convert';

import 'package:real_time_chat/models/user.dart';

class GetAllUsersModel {
  GetAllUsersModel({
    required this.ok,
    required this.users,
  });

  final bool ok;
  final List<User> users;

  factory GetAllUsersModel.fromJson(Map<String, dynamic> json) => GetAllUsersModel(
        ok: json["ok"],
        users: (json["users"] as List).map((e) => User.fromJson(e)).toList(),
      );
}
