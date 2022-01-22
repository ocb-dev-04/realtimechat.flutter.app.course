import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:real_time_chat/widgets/btns.dart';

Future<void> showAlert(BuildContext context, String title, String subtitle) async {
  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(subtitle),
        actions: [
          Buttom(
            label: 'OK',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        CupertinoDialogAction(
          child: const Text('OK'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}
