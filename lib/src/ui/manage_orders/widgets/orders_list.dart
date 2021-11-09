import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/ui/manage_orders/provider/orders_list_provider.dart';
import 'package:purchase_order/src/ui/manage_orders/widgets/order_card.dart';
import 'package:purchase_order/src/utils/global_functions.dart';
import 'package:shimmer/shimmer.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<OrdersListProvider>(context).orders != null) {
      if (Provider.of<OrdersListProvider>(context).orders!.isEmpty) {
        return emptyList();
      }
      return ordersList();
    } else {
      return shimmerOrdersList();
    }
  }

  ordersList() {
    return Consumer<OrdersListProvider>(builder: (_, provider, child) {
      return ListView.separated(
          itemBuilder: (_, int count) =>
              OrderCard(ordersPending: provider.orders![count]),
          physics: BouncingScrollPhysics(),
          separatorBuilder: (_, int count) =>
              GlobalFunctions.getVerticalSeparator(_, count),
          itemCount: provider.orders!.length);
    });
  }

  emptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.assignment_turned_in,
          color: Colors.grey,
          size: 30,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "No hay Ordenes pendientes",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  shimmerOrdersList() {
    return Shimmer.fromColors(
      child: ListView.separated(
        itemBuilder: (_, int count) => Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey,
          ),
        ),
        separatorBuilder: (_, int count) =>
            GlobalFunctions.getVerticalSeparator(_, count),
        itemCount: 48,
      ),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
    );
  }
}
