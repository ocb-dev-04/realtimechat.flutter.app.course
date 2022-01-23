import 'package:flutter/material.dart';
import 'package:real_time_chat/models/generic_response.dart';
import 'package:real_time_chat/models/user.dart';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:real_time_chat/global/enviroment.dart';
import 'package:real_time_chat/services/auth_services.dart';

class UserServices with ChangeNotifier {
  Future<List<User>> getUsers() async {
    try {
      final token = await AuthServices.getToken();
      final logged = await http.get(
        Uri.parse('${Enviroment.apiUrl}/users'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );
      if (logged.statusCode == 200) {
        final response = GetAllUsersModel.fromJson(json.decode(logged.body));
        return response.users;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
