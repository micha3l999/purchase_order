import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/no_scroll_behavior.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/global_widgets/product_card.dart';
import 'package:purchase_order/src/ui/cart/widgets/selected_product_card.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/dialogs.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';
import 'package:purchase_order/src/utils/global_functions.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartModel _cartModelProvider;

  @override
  void initState() {
    super.initState();

    _cartModelProvider = Provider.of<CartModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    double height = totalHeight -
        MediaQuery.of(context).padding.top -
        kToolbarHeight -
        MediaQuery.of(context).padding.bottom -
        (Dimensions.normalPadding * 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("XIAO"),
      ),
      body: Stack(
        children: [
          Container(
            height: totalHeight,
            padding: const EdgeInsets.all(Dimensions.normalPadding),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      "Carrito de compra",
                      style: Fonts.bigTitle,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    const Spacer(),
                    Consumer<CartModel>(builder: (context, cart, child) {
                      if (_cartModelProvider.products.length > 0) {
                        return PrimaryButton(
                          title: Row(
                            children: const [
                              Text("Eliminar todos"),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.remove_shopping_cart_outlined,
                                size: 20,
                              ),
                            ],
                          ),
                          onTap: removeAllItems,
                        );
                      }

                      return Row();
                    })
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                Expanded(
                  child: Consumer<CartModel>(builder: (context, cart, child) {
                    if (cart.products.length < 1) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const MyIconEmpty(),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "No hay productos agregados al carrito",
                            style: Fonts.title.copyWith(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.separated(
                      itemBuilder: (_, int count) {
                        if (count != (_cartModelProvider.products.length - 1)) {
                          return SelectedProductCard(
                              product: _cartModelProvider.products[count]);
                        }
                        return SelectedProductCard(
                          product: _cartModelProvider.products[count],
                          lastItem: true,
                        );
                      },
                      separatorBuilder: GlobalFunctions.getVerticalSeparator,
                      itemCount: _cartModelProvider.products.length,
                    );
                  }),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 70,
              width: width,
              child: Material(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                elevation: 20,
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.normalPadding),
                  child: Consumer<CartModel>(builder: (context, cart, child) {
                    return Center(
                      child: RichText(
                          text: TextSpan(
                              text: "Total de la orden:  ",
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                              children: [
                            TextSpan(
                              text: " \$" + cart.totalPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: primaryColor,
                                  fontSize: 18),
                            )
                          ])),
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  removeAllItems() {
    _cartModelProvider.removeAll();
    Dialogs.informationDialog(context,
        title: "Se han eliminado todos los productos de la orden");
  }
}
