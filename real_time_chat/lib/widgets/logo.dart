import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width / 3,
      child: Column(
        children: [
          Image.asset(
            'assets/images/tag-logo.png',
            width: size.width / 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Messenger',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
    );
  }
}
