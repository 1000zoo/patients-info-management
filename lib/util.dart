import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ediya/config.dart';

Text getText(String string) {
  return Text(string, style: TEXT_STYLE, textAlign: TextAlign.center,);
}

Future<dynamic> getAlertDialog(BuildContext context, String error) {
  return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(error, style: TEXT_STYLE_FOR_ALERT_DIALOG),
          actions: [
            CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        );
      }
  );
}

///Todo util.dart 및 config.dart 편의성 개선 (안해도 됨)
