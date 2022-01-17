import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  const Labels({
    Key? key,
    this.isInLogin = false,
  }) : super(key: key);

  final bool isInLogin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            isInLogin ? 'No tienes cuenta?' : 'Ya tienes cuenta?',
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.w300,
                  color: Colors.black54,
                ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, isInLogin ? 'signup' : 'login'),
            child: Text(isInLogin ? 'Crea una ahora!' : 'Inicia sesión'),
          )
        ],
      ),
    );
  }
}
