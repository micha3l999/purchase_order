import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/ui/create/models/warehouse.dart';
import 'package:purchase_order/src/ui/report_stock/repository/report_stock_repository.dart';

class WarehousesProvider {
  List<Warehouse>? warehousesList;

  Future<void> fetchWarehouses() async {
    warehousesList = await ReportStock.getWarehouses();
  }
}
