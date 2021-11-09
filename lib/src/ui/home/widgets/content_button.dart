import 'package:flutter/material.dart';

class ContentButton extends StatelessWidget {
  const ContentButton({Key? key, required this.image, required this.title})
      : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: Image.asset("assets/images/$image").image,
          fit: BoxFit.fill,
        ),
        Container(
          child: Center(child: Text(title)),
        ),
      ],
    );
  }
}
