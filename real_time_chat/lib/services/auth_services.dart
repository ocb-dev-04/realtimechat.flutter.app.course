import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:real_time_chat/global/enviroment.dart';
import 'package:real_time_chat/models/user.dart';

class AuthServices with ChangeNotifier {
  User? user;

  Future<bool> login(String email, String pass) async {
    assert(email.isNotEmpty, 'user is empty');
    assert(pass.isNotEmpty, 'pass is empty');
    assert(pass.length > 5, 'pass is short');

    try {
      final data = {
        'email': email,
        'password': pass,
      };

      final logged = await http.post(
        Uri.parse('${Enviroment.apiUrl}/account/login'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // final user = User.fromJson(json.decode(logged.body));

      debugPrint(logged.body);
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> signup(String name, String email, String pass) async {
    assert(name.isNotEmpty, 'name is empty');
    assert(email.isNotEmpty, 'user is empty');
    assert(pass.isNotEmpty, 'pass is empty');
    assert(pass.length > 5, 'pass is short');

    return Future.value(true);
  }
}
