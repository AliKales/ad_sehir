import 'package:flutter/material.dart';

import 'colors.dart';

class SimpleUIs {
  static Widget elevatedButton({
    required context,
    required Function() onPress,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: () {
        onPress.call();
      },
      style: ElevatedButton.styleFrom(primary: color3),
      child: Text(text, style: const TextStyle(color: color4)),
    );
  }
}
