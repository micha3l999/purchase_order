import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/product_type_selected.dart';
import 'package:purchase_order/src/ui/report_stock/provider/report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/product_type_option.dart';
import 'package:shimmer/shimmer.dart';

class ProductTypesList extends StatefulWidget {
  const ProductTypesList({Key? key}) : super(key: key);

  @override
  State<ProductTypesList> createState() => _ProductTypesListState();
}

class _ProductTypesListState extends State<ProductTypesList> {
  late ReportProvider _reportProvider;
  late ProductTypeSelectedProvider _typeSelectedProvider;

  @override
  void initState() {
    super.initState();

    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _typeSelectedProvider =
        Provider.of<ProductTypeSelectedProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<ReportProvider>(context).loading &&
        Provider.of<ReportProvider>(context)
            .productTypesProvider
            .productsReportTypes!
            .isNotEmpty) {
      return productTypeList();
    } else {
      return productTypesShimmer();
    }
  }

  productTypesShimmer() {
    return SizedBox(
      height: 43,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: ListView.separated(
          separatorBuilder: (_, int count) => const SizedBox(
            width: 8,
          ),
          itemBuilder: (_, int count) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: 15,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
            ),
          ),
          itemCount: 9,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  productTypeList() {
    _typeSelectedProvider.selectedProductType =
        _reportProvider.productTypesProvider.productsReportTypes![0];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        separatorBuilder: (_, int count) => const SizedBox(
          width: 8,
        ),
        itemBuilder: (_, int count) {
          return ProductTypeOption(
            productTypes: _reportProvider
                .productTypesProvider.productsReportTypes![count],
          );
        },
        itemCount:
            _reportProvider.productTypesProvider.productsReportTypes?.length ??
                0,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
