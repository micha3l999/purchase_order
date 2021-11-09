import 'package:flutter/material.dart';

abstract class Dialogs {
  static const String defaultOk = "Ok";
  static void alertDialog(BuildContext context,
      {required String title, String body = ""}) {
    AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          child: const Text(defaultOk),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  static Future<void> informationDialog(BuildContext context,
      {required String title, String body = ""}) async {
    await showDialog<void>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.grey.shade600),
            ),
          );
        });
  }
}
