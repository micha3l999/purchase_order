import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/ui/report_stock/provider/product_type_selected.dart';
import 'package:purchase_order/src/ui/report_stock/provider/product_types.dart';
import 'package:purchase_order/src/ui/report_stock/provider/products_report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/warehouse_selected.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/product_types_list.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/products_list.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/warehouses_list.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class ReportStockView extends StatefulWidget {
  const ReportStockView({Key? key}) : super(key: key);

  @override
  State<ReportStockView> createState() => _ReportStockViewState();
}

class _ReportStockViewState extends State<ReportStockView> {
  late ProductsReportProvider _productsReportProvider;
  late ReportProvider _reportProvider;

  @override
  void initState() {
    super.initState();
    initProviderFetching();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductTypeSelectedProvider>(
          create: (_) => ProductTypeSelectedProvider(),
        ),
        ChangeNotifierProvider<WarehouseSelectedProvider>(
          create: (_) => WarehouseSelectedProvider(),
        ),
        ChangeNotifierProvider.value(value: _productsReportProvider),
        ChangeNotifierProvider.value(value: _reportProvider),
      ],
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(Dimensions.normalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reporte de stock",
                      style: Fonts.bigTitle,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  MyIconHouse(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Bodegas",
                    style: Fonts.title,
                  ),
                ],
              ),
              WarehousesList(),
              Row(
                children: [
                  MyIconCategories(),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Tipos de productos",
                    style: Fonts.title,
                  ),
                ],
              ),
              ProductTypesList(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone_android,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Productos",
                      style: Fonts.title,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ProductReportList(),
            ],
          ),
        ),
      ),
    );
  }

  initProviderFetching() {
    _productsReportProvider = ProductsReportProvider();
    _reportProvider = ReportProvider(_productsReportProvider);
    _reportProvider.loadDataReport();
  }
}
