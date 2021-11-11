import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/models/product_selected.dart';
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/utils/dialogs.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:transparent_image/transparent_image.dart';

class SelectedProductCard extends StatefulWidget {
  final ProductSelected product;
  const SelectedProductCard({
    Key? key,
    required this.product,
    this.lastItem = false,
  }) : super(key: key);

  final bool lastItem;

  @override
  _SelectedProductCardState createState() => _SelectedProductCardState();
}

class _SelectedProductCardState extends State<SelectedProductCard> {
  late CartModel _cartModelProvider;

  @override
  void initState() {
    super.initState();

    initProvider();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: widget.lastItem ? 56 : 0),
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.littlePadding),
                      alignment: Alignment.center,
                      child: widget.product.image != null
                          ? FadeInImage.memoryNetwork(
                              image:
                                  "${ApiInstance.baseURL.substring(0, (ApiInstance.baseURL.length - 10))}${widget.product.image}",
                              placeholder: kTransparentImage,
                              imageErrorBuilder: (_, object, stackTrace) {
                                return AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Opps...",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            Dimensions.zeroPadding,
                            Dimensions.normalPadding,
                            Dimensions.normalPadding,
                            Dimensions.normalPadding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              Text(
                                widget.product.description ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "Código: " + widget.product.code!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Precio Total: " +
                                    getTotalPrice().toStringAsFixed(2),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Cantidad: " + widget.product.quantity!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 6)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.red.shade800,
                                        )),
                                    onPressed: removeItemCart,
                                    child: Row(
                                      children: const [
                                        Text("Eliminar producto"),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Icon(Icons.remove),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        //
                        // put a top right icon to delete the product from the order
                        //
                        /*Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: removeItemCart,
                            icon: const MyIconRemove(),
                          ),
                        )*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  initProvider() {
    _cartModelProvider = Provider.of<CartModel>(context, listen: false);
  }

  removeItemCart() {
    _cartModelProvider.removeItem(widget.product.code!, getTotalPrice());
    Dialogs.informationDialog(context, title: "Producto eliminado");
  }

  double getTotalPrice() {
    return double.parse(widget.product.price!) *
        double.parse(widget.product.quantity!);
  }
}
