import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/services/auth_services.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  Future<void> _isLoggedIn(BuildContext context) async {
    final authServices = Provider.of<AuthServices>(context);
    final isLogged = await authServices.isLoggedIn();

    if (isLogged) {
      // TODO: connect to sockets
      Navigator.pushReplacementNamed(context, 'users');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _isLoggedIn(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
