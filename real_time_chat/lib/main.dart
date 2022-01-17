import 'package:flutter/material.dart';
import 'package:real_time_chat/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Here Chat',
      initialRoute: 'chat',
      routes: appRoutes,
    );
  }
}
