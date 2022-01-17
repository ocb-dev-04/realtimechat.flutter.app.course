import 'package:flutter/material.dart';
import 'package:real_time_chat/pages/chat_page.dart';
import 'package:real_time_chat/pages/loading_page.dart';
import 'package:real_time_chat/pages/login_page.dart';
import 'package:real_time_chat/pages/signup_page.dart';
import 'package:real_time_chat/pages/users_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'loading': (_) => const LoadingPage(),
  'login': (_) => const LoginPage(),
  'chat': (_) => const ChatPage(),
  'signup': (_) => const SignupPage(),
  'users': (_) => const UsersPage(),
};
