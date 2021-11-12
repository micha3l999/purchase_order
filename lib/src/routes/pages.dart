import 'package:flutter/material.dart';
import 'package:purchase_order/src/ui/cart/view/cart_page.dart';
import 'package:purchase_order/src/ui/client/view/client_page.dart';
import 'package:purchase_order/src/ui/create/view/create_page.dart';
import 'package:purchase_order/src/ui/home/view/home_page.dart';
import 'package:purchase_order/src/ui/login/view/login_page.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/manage_orders/view/manage_orders.dart';
import 'package:purchase_order/src/ui/manage_orders/view/order_detail_page.dart';
import 'package:purchase_order/src/ui/past_orders/view/past_orders_page.dart';

abstract class Pages {
  static const String initial = "/login";

  static final Map<String, Widget Function(BuildContext context)> routes = {
    Routes.login: (_) => const Login(),
    Routes.createOrder: (_) => const CreatePage(),
    Routes.home: (_) => const Home(),
    Routes.editOrder: (_) => const ManageOrders(),
    Routes.clientPage: (_) => const ClientPage(),
    Routes.cartPage: (_) => const CartPage(),
    Routes.orderInformation: (_) => const OrderDetailPage(),
    Routes.pastOrdersPage: (_) => const PastOrdersPage()
  };
}
