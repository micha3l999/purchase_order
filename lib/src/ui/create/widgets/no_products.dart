import 'package:flutter/material.dart';

class NoProducts extends StatelessWidget {
  const NoProducts({Key? key, this.count}) : super(key: key);

  final int? count;
  final String textNoData = "No hay Productos según el filtro seleccionado";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text(textNoData),
    ));
  }
}
