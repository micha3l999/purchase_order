import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/ui/create/models/warehouse.dart';
import 'package:purchase_order/src/ui/report_stock/provider/product_types.dart';
import 'package:purchase_order/src/ui/report_stock/provider/products_report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/warehouses.dart';

class ReportProvider extends ChangeNotifier {
  final WarehousesProvider warehousesProvider = WarehousesProvider();
  final ProductTypesProvider productTypesProvider = ProductTypesProvider();
  final ProductsReportProvider _productsReportProvider;
  bool loading = true;

  ReportProvider(this._productsReportProvider);

  Future<void> loadDataReport() async {
    await Future.wait([
      warehousesProvider.fetchWarehouses(),
      productTypesProvider.fetchProductsTypes()
    ]);

    if (warehousesProvider.warehousesList != null &&
        warehousesProvider.warehousesList!.isNotEmpty &&
        productTypesProvider.productsReportTypes != null &&
        productTypesProvider.productsReportTypes!.isNotEmpty) {
      await _productsReportProvider.fetchProductsReport(
          "30", productTypesProvider.productsReportTypes![0].code);
      loading = false;
      notifyListeners();
    }
  }
}
