import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/ui/report_stock/models/product_types.dart';
import 'package:purchase_order/src/ui/report_stock/provider/product_type_selected.dart';
import 'package:purchase_order/src/ui/report_stock/provider/products_report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/warehouse_selected.dart';
import 'package:purchase_order/src/utils/colors.dart';

class ProductTypeOption extends StatefulWidget {
  const ProductTypeOption({Key? key, required this.productTypes})
      : super(key: key);

  final ProductTypes productTypes;

  @override
  State<ProductTypeOption> createState() => _ProductTypeOptionState();
}

class _ProductTypeOptionState extends State<ProductTypeOption> {
  late ProductsReportProvider _productsReportProvider;
  late WarehouseSelectedProvider _warehouseSelectedProvider;

  @override
  void initState() {
    super.initState();

    _productsReportProvider =
        Provider.of<ProductsReportProvider>(context, listen: false);
    _warehouseSelectedProvider =
        Provider.of<WarehouseSelectedProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child:
          Consumer<ProductTypeSelectedProvider>(builder: (_, provider, child) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: provider.selectedProductType!.code == widget.productTypes.code
              ? primaryColor
              : Colors.white,
          elevation: 8,
          child: InkWell(
            onTap: () {
              provider.updateSelectedProductType(widget.productTypes);
              _productsReportProvider.clearProductsReport();
              Provider.of<ProductsReportProvider>(context, listen: false)
                  .updateProductsReport(
                      _warehouseSelectedProvider.warehouseSelected!.code,
                      provider.selectedProductType!.code);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  widget.productTypes.description,
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      color: provider.selectedProductType!.code ==
                              widget.productTypes.code
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
