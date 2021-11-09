import 'package:flutter/material.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/global_functions.dart';
import 'package:shimmer/shimmer.dart';

class ProductListShimmer extends StatelessWidget {
  const ProductListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.separated(
        itemBuilder: (_, int count) => Container(
          height: 200,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey,
          ),
        ),
        separatorBuilder: (_, int count) =>
            GlobalFunctions.getVerticalSeparator(_, count),
        itemCount: 8,
      ),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
    );
  }
}
