import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/routes/routes.dart';
import 'package:real_time_chat/services/auth_services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Here Chat',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
