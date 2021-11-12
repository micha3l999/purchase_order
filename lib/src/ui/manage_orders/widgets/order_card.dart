import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/manage_orders/models/orders_pending.dart';
import 'package:purchase_order/src/ui/manage_orders/provider/orders_list_provider.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({Key? key, required this.ordersPending}) : super(key: key);

  final OrdersPending ordersPending;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late OrdersListProvider _ordersListProvider;

  @override
  void initState() {
    super.initState();

    _ordersListProvider =
        Provider.of<OrdersListProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText("Código:"),
                        Text(widget.ordersPending.code),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText("Tipo:"),
                        Text(
                          widget.ordersPending.type,
                          style: TextStyle(
                            color: widget.ordersPending.type == "PROFORMA"
                                ? Colors.black
                                : Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleText("Nombre del cliente:"),
                        Text(widget.ordersPending.clientName),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget.ordersPending.type == "PROFORMA"
                        ? PrimaryButton(
                            title: textButton("Aplicar", MyIconApplyProforma()),
                            colorButton: Colors.blueGrey.shade600,
                            onTap: () {
                              applyProforma(widget.ordersPending.code);
                            })
                        : Container(),
                    widget.ordersPending.type == "PROFORMA"
                        ? const SizedBox(width: 5)
                        : Container(),
                    PrimaryButton(
                        title:
                            textButton("Consultar", MyIconInformationOrder()),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.orderInformation,
                            arguments: {"data": widget.ordersPending},
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              deleteOrder(widget.ordersPending.code, widget.ordersPending.type);
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red.shade800,
            ),
          ),
        )
      ],
    );
  }

  convertRichText(String title, String body) {
    return RichText(
        text: TextSpan(text: title, children: [
      TextSpan(
        text: body,
      )
    ]));
  }

  titleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.littleBitPadding),
      child: Text(
        text,
        style: Fonts.regular,
      ),
    );
  }

  textButton(String text, Widget icon) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),
        Text(text),
      ],
    );
  }

  Future<void> applyProforma(String codeProforma) async {
    _ordersListProvider.loadOrders();
    await _ordersListProvider.applyProforma(codeProforma);
  }

  Future<void> deleteOrder(String code, String type) async {
    _ordersListProvider.loadOrders();

    await _ordersListProvider.deleterOrder(code, type);
  }

  Future<void> getOrderInformation(String code, String type) async {
    await _ordersListProvider.getOrderDetails(code, type);
  }
}
