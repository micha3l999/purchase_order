import 'package:flutter/material.dart';

class RoundedRemoveIconButton extends StatelessWidget {
  const RoundedRemoveIconButton(
      {Key? key, required this.removeFunction, this.size = 15})
      : super(key: key);

  final void Function() removeFunction;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      icon: const Icon(
        Icons.remove,
        color: Colors.red,
      ),
      onPressed: removeFunction,
    );
  }
}
