import 'package:flutter/foundation.dart';
import 'package:purchase_order/src/ui/manage_orders/models/order_details.dart';
import 'package:purchase_order/src/ui/manage_orders/models/orders_pending.dart';
import 'package:purchase_order/src/ui/manage_orders/repository/manage_orders_repository.dart';
import 'package:purchase_order/src/ui/manage_orders/repository/manage_orders_routes.dart';

class OrdersListProvider extends ChangeNotifier {
  List<OrdersPending>? orders;

  Future<void> fetchPendingOrder() async {
    orders = await ManageOrdersRepository.getOrdersPending();
    notifyListeners();
  }

  Future<void> applyProforma(String codeProforma) async {
    bool wasApplied = await ManageOrdersRepository.applyProforma(codeProforma);
    if (wasApplied && orders != null) {
      orders!.removeWhere((element) => element.code == codeProforma);
    }
    orders = await ManageOrdersRepository.getOrdersPending();
    notifyListeners();
  }

  Future<OrderDetails?> getOrderDetails(String code, String type) async {
    OrderDetails? orderDetails =
        await ManageOrdersRepository.getOrdersDetails(type, code);
    if (orderDetails != null) {
      return orderDetails;
    }
    return null;
  }

  Future<void> deleterOrder(String orderCode, String type) async {
    bool deleted =
        await ManageOrdersRepository.deletePendingOrder(type, orderCode);
    if (deleted && orders != null) {
      orders!.removeWhere((element) => element.code == orderCode);
    }
    orders = await ManageOrdersRepository.getOrdersPending();
    notifyListeners();
  }

  void loadOrders() {
    orders = null;
    notifyListeners();
  }
}
