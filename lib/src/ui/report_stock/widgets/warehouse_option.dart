import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/ui/create/models/warehouse.dart';
import 'package:purchase_order/src/ui/report_stock/provider/product_type_selected.dart';
import 'package:purchase_order/src/ui/report_stock/provider/products_report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/warehouse_selected.dart';
import 'package:purchase_order/src/utils/colors.dart';

class WarehouseOption extends StatefulWidget {
  const WarehouseOption({Key? key, required this.warehouse}) : super(key: key);

  final Warehouse warehouse;

  @override
  State<WarehouseOption> createState() => _WarehouseOptionState();
}

class _WarehouseOptionState extends State<WarehouseOption> {
  late ProductsReportProvider _productsReportProvider;
  late ProductTypeSelectedProvider _productTypeSelectedProvider;

  @override
  void initState() {
    super.initState();

    _productsReportProvider =
        Provider.of<ProductsReportProvider>(context, listen: false);
    _productTypeSelectedProvider =
        Provider.of<ProductTypeSelectedProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Consumer<WarehouseSelectedProvider>(builder: (_, provider, child) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: widget.warehouse.code == provider.warehouseSelected!.code
              ? primaryColor
              : Colors.white,
          elevation: 8,
          child: InkWell(
            onTap: () {
              provider.updateWarehouseSelected(widget.warehouse);
              _productsReportProvider.clearProductsReport();

              Provider.of<ProductsReportProvider>(context, listen: false)
                  .updateProductsReport(provider.warehouseSelected!.code,
                      _productTypeSelectedProvider.selectedProductType!.code);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                  widget.warehouse.description,
                  style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: widget.warehouse.code ==
                              provider.warehouseSelected!.code
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
