import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:real_time_chat/global/enviroment.dart';
import 'package:real_time_chat/models/message.dart';
import 'package:real_time_chat/models/user.dart';
import 'package:http/http.dart' as http;

import 'auth_services.dart';

class ChatServices with ChangeNotifier {
  User? toUser;

  Future<List<Message>> getMessages(String toUserUid) async {
    try {
      final token = await AuthServices.getToken();
      final logged = await http.get(
        Uri.parse('${Enviroment.apiUrl}/messages/$toUserUid'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );
      if (logged.statusCode == 200) {
        final response = MessagesResponseModel.fromJson(jsonDecode(logged.body));
        return response.messages;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
