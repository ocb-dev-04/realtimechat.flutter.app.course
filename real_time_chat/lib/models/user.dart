import 'dart:convert';

class User {
  User({
    required this.name,
    required this.email,
    required this.online,
    required this.uid,
  });

  final String name;
  final String email;
  final bool online;
  final String uid;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"].toString(),
        email: json["email"].toString(),
        online: json["online"] as bool,
        uid: json["uid"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "online": online,
        "uid": uid,
      };
}
