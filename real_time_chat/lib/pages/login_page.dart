import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/helpers/alerts.dart';
import 'package:real_time_chat/services/auth_services.dart';
import 'package:real_time_chat/services/socket_services.dart';
import 'package:real_time_chat/widgets/btns.dart';
import 'package:real_time_chat/widgets/custom_inputs.dart';
import 'package:real_time_chat/widgets/labels.dart';
import 'package:real_time_chat/widgets/logo.dart';
import 'package:real_time_chat/widgets/terms_and_conditions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                Logo(),
                _Form(),
                Labels(isInLogin: true),
                TermsAndConditions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context);
    final socketService = Provider.of<SocketServices>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomInput(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            placerholder: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 20),
          CustomInput(
            controller: _passwordController,
            placerholder: 'Password',
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          const SizedBox(height: 20),
          Buttom(
            label: 'Acceder',
            onPressed: () async {
              FocusScope.of(context).unfocus();

              final result = await authService.login(
                _emailController.text.trim(),
                _passwordController.text.trim(),
              );

              if (result) {
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'users');
              } else {
                showAlert(context, 'Ups.. error', 'Revisa tus credenciales');
              }
            },
          ),
        ],
      ),
    );
  }
}
