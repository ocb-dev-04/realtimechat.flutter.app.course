import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:real_time_chat/global/enviroment.dart';
import 'package:real_time_chat/models/login_response.dart';
import 'package:real_time_chat/models/user.dart';

class AuthServices with ChangeNotifier {
  User? currenUser;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String pass) async {
    assert(email.isNotEmpty, 'user is empty');
    assert(pass.isNotEmpty, 'pass is empty');
    assert(pass.length > 5, 'pass is short');
    this.loading = true;
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
      if (logged.statusCode == 200) {
        final user = LoginResponseModel.fromJson(json.decode(logged.body));
        this.currenUser = user.user;
        return user.ok;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      this.loading = false;
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
