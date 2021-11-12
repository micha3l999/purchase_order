import 'package:flutter/material.dart';
import 'package:purchase_order/src/ui/manage_orders/models/item_details.dart';
import 'package:purchase_order/src/ui/manage_orders/models/order_details.dart';
import 'package:purchase_order/src/ui/manage_orders/models/orders_pending.dart';
import 'package:purchase_order/src/ui/manage_orders/repository/manage_orders_repository.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/product_stock_card.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final args = mapArgs["data"];
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("XIAO"),
      ),
      body: SafeArea(
        child: Container(
          width: width,
          child: Card(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Detalles de la Orden",
                      style: Fonts.bigTitle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  child: const Divider(),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.normalPadding,
                    horizontal: Dimensions.littlePadding,
                  ),
                  child: Column(
                    children: [
                      rowInformation("Código: ", args.code),
                      rowInformation("Tipo: ", args.type),
                      rowInformation("Cliente: ", args.clientName),
                    ],
                  ),
                ),
                Expanded(
                  child: productsList(args),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  rowInformation(String titleText, String textBody) {
    return Row(
      children: [
        Text(
          titleText,
          style: Fonts.title,
        ),
        Text(textBody),
      ],
    );
  }

  productsList(args) {
    return FutureBuilder(
        future: ManageOrdersRepository.getOrdersDetails(args.type, args.code),
        builder: (context, AsyncSnapshot<OrderDetails?> snapshot) {
          if (snapshot.hasData) {
            double totalPrice = 0;
            double ivaTotal = 0;
            List<ItemDetails> items = snapshot.data!.items;
            List<TableRow> reportList = [];
            reportList.add(
              TableRow(children: [
                Column(children: [
                  Container(
                    child: Text('Cantidad', style: TextStyle(fontSize: 13.8)),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  )
                ]),
                Column(children: [
                  Container(
                    child: Text('Producto', style: TextStyle(fontSize: 14.0)),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                  )
                ]),
                Column(children: [
                  Container(
                    child: Text('Precio', style: TextStyle(fontSize: 14.0)),
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  )
                ]),
                Column(children: [
                  Container(
                    child: Text('Subtotal', style: TextStyle(fontSize: 14.0)),
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  )
                ]),
              ]),
            );
            for (int i = 0; i < items.length; i++) {
              totalPrice = totalPrice + double.parse(items[i].total);
              ivaTotal = ivaTotal + double.parse(items[i].ivaPrice);
              reportList.add(
                TableRow(children: [
                  Column(children: [
                    ProductStockCard(
                      text: items[i].quantity,
                    )
                  ]),
                  Column(children: [
                    ProductStockCard(
                      text: items[i].product,
                    )
                  ]),
                  Column(children: [
                    ProductStockCard(
                      text: items[i].unitValue,
                      isPrice: true,
                    )
                  ]),
                  Column(children: [
                    ProductStockCard(
                      text: items[i].subtotal,
                      isPrice: true,
                    )
                  ]),
                ]),
              );
            }
            return Stack(
              children: [
                ListView(physics: BouncingScrollPhysics(), children: [
                  Container(
                    color: whiteColor,
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.7),
                        1: FlexColumnWidth(2.5),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1.8),
                      },
                      border: TableBorder.all(
                          color: Colors.black26,
                          style: BorderStyle.solid,
                          width: 2),
                      children: [
                        ...reportList,
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ]),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Material(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        elevation: 20,
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.normalPadding),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                RichText(
                                    text: TextSpan(
                                        text: "Total:  ",
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                        children: [
                                      TextSpan(
                                        text: " \$" +
                                            totalPrice.toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: primaryColor,
                                            fontSize: 18),
                                      )
                                    ])),
                                const Spacer(),
                                RichText(
                                    text: TextSpan(
                                        text: "Iva total:  ",
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .copyWith(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                        children: [
                                      TextSpan(
                                        text:
                                            " \$" + ivaTotal.toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: primaryColor,
                                            fontSize: 18),
                                      )
                                    ])),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
