import 'package:flutter/material.dart';

class Buttom extends StatelessWidget {
  const Buttom({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: const StadiumBorder(),
      color: Colors.blue,
      textColor: Colors.white,
      height: 50,
      child: Text(label),
    );
  }
}
