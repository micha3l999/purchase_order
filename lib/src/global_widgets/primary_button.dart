import 'package:flutter/material.dart';
import 'package:purchase_order/src/utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.colorButton = primaryColor})
      : super(key: key);

  final Widget title;
  final Function() onTap;
  final Color colorButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: title,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            horizontal: (7 + MediaQuery.of(context).size.height * 0.001))),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        backgroundColor: MaterialStateProperty.all(colorButton),
      ),
    );
  }
}
