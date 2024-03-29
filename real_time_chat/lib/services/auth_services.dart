import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:real_time_chat/global/constants.dart';

import 'package:real_time_chat/global/enviroment.dart';
import 'package:real_time_chat/models/login_response.dart';
import 'package:real_time_chat/models/user.dart';

class AuthServices with ChangeNotifier {
  late User currenUser;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final _secureStorage = const FlutterSecureStorage();

  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: Constants.tokenKey);
    return token ?? '';
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
        await _saveJWT(user.token);

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
    this.loading = true;
    try {
      final data = {
        'name': name,
        'email': email,
        'password': pass,
      };

      final logged = await http.post(
        Uri.parse('${Enviroment.apiUrl}/account/new'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (logged.statusCode == 200) {
        final user = LoginResponseModel.fromJson(json.decode(logged.body));
        this.currenUser = user.user;
        await _saveJWT(user.token);

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

  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      if (token.isEmpty) {
        return false;
      }
      final logged = await http.get(
        Uri.parse('${Enviroment.apiUrl}/account/refreshJWT'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );
      if (logged.statusCode == 200) {
        final user = LoginResponseModel.fromJson(json.decode(logged.body));
        this.currenUser = user.user;
        return user.ok;
      } else {
        await _clearJWT();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    //TODO: Disconnect from sockets
    // then, clear jwt
    await _clearJWT();
  }

  Future<void> _saveJWT(String token) => _secureStorage.write(key: Constants.tokenKey, value: token);

  Future<void> _clearJWT() => _secureStorage.delete(key: Constants.tokenKey);
}
