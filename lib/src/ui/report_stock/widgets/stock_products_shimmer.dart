import 'package:flutter/material.dart';
import 'package:purchase_order/src/utils/global_functions.dart';
import 'package:shimmer/shimmer.dart';

class StockProductShimmer extends StatelessWidget {
  const StockProductShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.separated(
        itemBuilder: (_, int count) => Container(
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.grey,
          ),
        ),
        separatorBuilder: (_, int count) =>
            GlobalFunctions.getVerticalSeparator(_, count),
        itemCount: 48,
      ),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
    );
  }
}
