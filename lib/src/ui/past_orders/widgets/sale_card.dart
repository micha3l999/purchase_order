import 'package:flutter/material.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/past_orders/models/past_sale.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class SaleCard extends StatelessWidget {
  const SaleCard({Key? key, required this.sale}) : super(key: key);

  final PastSale sale;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 185,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText("Código:"),
                    Text(sale.code),
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
                      sale.type,
                      style: TextStyle(
                        color: sale.type == "PROFORMA"
                            ? Colors.black
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleText("Total de la orden:"),
                    Text("\$${sale.total}"),
                  ],
                ),
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
                    Text(sale.clientName),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Spacer(),
                PrimaryButton(
                    title: Row(
                      children: const [
                        MyIconInformationOrder(),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Consultar"),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        Routes.orderInformation,
                        arguments: {"data": sale},
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
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
}
