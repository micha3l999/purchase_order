import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/ui/create/models/warehouse.dart';

class WarehouseSelectedProvider extends ChangeNotifier {
  Warehouse? warehouseSelected;

  void updateWarehouseSelected(Warehouse value) {
    warehouseSelected = value;
    notifyListeners();
  }
}
