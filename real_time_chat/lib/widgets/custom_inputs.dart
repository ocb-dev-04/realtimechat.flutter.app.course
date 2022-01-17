import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    required this.controller,
    required this.placerholder,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.prefixIcon,
  }) : super(key: key);

  final TextEditingController controller;
  final TextInputType keyboardType;
  final String placerholder;
  final bool isPassword;
  final Icon prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        autocorrect: false,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          hintText: placerholder,
        ),
      ),
    );
  }
}
