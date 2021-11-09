import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({Key? key, required this.text, required this.width})
      : super(key: key);

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      alignment: Alignment.center,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        shape: BoxShape.rectangle,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
