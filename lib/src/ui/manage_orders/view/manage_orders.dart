import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/global_widgets/search_bar.dart';
import 'package:purchase_order/src/ui/manage_orders/provider/orders_list_provider.dart';
import 'package:purchase_order/src/ui/manage_orders/widgets/orders_list.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({Key? key}) : super(key: key);

  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  final OrdersListProvider _ordersListProvider = OrdersListProvider();

  @override
  void initState() {
    super.initState();
    _ordersListProvider.fetchPendingOrder();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: _ordersListProvider,
        ),
      ],
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(Dimensions.normalPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assignment,
                    size: 22,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Ordenes pendientes",
                    style: Fonts.bigTitle,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              const Expanded(child: OrdersList()),
            ],
          ),
        ),
      ),
    );
  }
}
