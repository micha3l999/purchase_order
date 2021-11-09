import 'package:flutter/material.dart';
import 'package:purchase_order/src/ui/report_stock/models/product_report.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/header_text.dart';

class ProductStockCard extends StatelessWidget {
  const ProductStockCard({Key? key, required this.text, this.isPrice = false})
      : super(key: key);

  final String text;
  final bool isPrice;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String textConverted = text;
    if (isPrice) {
      textConverted = double.parse(text).toStringAsFixed(2);
      if (textConverted.length >= 8) {
        textConverted = double.parse(textConverted).toStringAsFixed(1);
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      alignment: Alignment.center,
      child: Text(
        textConverted,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
