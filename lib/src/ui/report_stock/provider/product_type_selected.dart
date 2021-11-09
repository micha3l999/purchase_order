import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/ui/report_stock/models/product_types.dart';

class ProductTypeSelectedProvider extends ChangeNotifier {
  ProductTypes? selectedProductType;

  void updateSelectedProductType(ProductTypes value) {
    selectedProductType = value;
    notifyListeners();
  }
}
