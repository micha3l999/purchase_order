import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/ui/report_stock/models/product_report.dart';
import 'package:purchase_order/src/ui/report_stock/repository/report_stock_repository.dart';

class ProductsReportProvider extends ChangeNotifier {
  List<ProductReport>? productsReport;

  Future<void> fetchProductsReport(String warehouse, String productType) async {
    productsReport =
        await ReportStock.getProductsReport(warehouse, productType);
  }

  void updateProductsReport(String warehouse, String productType) async {
    productsReport =
        await ReportStock.getProductsReport(warehouse, productType);
    notifyListeners();
  }

  void clearProductsReport() {
    productsReport = null;
    notifyListeners();
  }
}
