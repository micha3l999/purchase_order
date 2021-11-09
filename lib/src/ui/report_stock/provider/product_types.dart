import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/ui/report_stock/models/product_types.dart';
import 'package:purchase_order/src/ui/report_stock/repository/report_stock_repository.dart';

class ProductTypesProvider {
  List<ProductTypes>? productsReportTypes;

  Future<void> fetchProductsTypes() async {
    productsReportTypes = await ReportStock.getProductStockTypes();
  }
}
