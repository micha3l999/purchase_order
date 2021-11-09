import 'package:flutter/material.dart';

abstract class GlobalFunctions {
  static Widget getVerticalSeparator(_, int count) => const SizedBox(
        height: 5,
      );
  static Widget noVerticalSeparator(_, int count) => const SizedBox();
}
