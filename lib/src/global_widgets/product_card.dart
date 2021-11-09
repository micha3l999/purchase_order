import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/global_widgets/quantity_selector.dart';
import 'package:purchase_order/src/models/product.dart';
import 'package:purchase_order/src/models/product_selected.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/utils/dialogs.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard(
      {Key? key,
      required this.product,
      this.lastItem = false,
      required this.warehouse})
      : super(key: key);

  final bool lastItem;
  final String warehouse;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late CartModel cartModelProvider;

  final ValueNotifier<String?> _selectedPrice = ValueNotifier(null);

  // Update the price of the drop down button
  final ValueNotifier<String?> _priceValue = ValueNotifier(null);

  // For getting the selected quantity by the user
  final GlobalKey<QuantitySelectorState> _quantitySelectorKey = GlobalKey();

  late FocusNode _dropFocus;

  @override
  void initState() {
    super.initState();

    initProvider();
    _dropFocus = FocusNode();
  }

  @override
  void dispose() {
    _dropFocus.dispose();
    _selectedPrice.dispose();
    super.dispose();
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
                      child: FadeInImage.memoryNetwork(
                        image: widget.product.image,
                        placeholder: kTransparentImage,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Padding(
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
                            Text(
                              widget.product.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Código: " + widget.product.code,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 13),
                                ),
                                width < 675
                                    ? const Spacer()
                                    : const SizedBox(
                                        width: 30,
                                      ),
                                const Text(
                                  "Precio:  ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                ValueListenableBuilder(
                                    valueListenable: _selectedPrice,
                                    builder:
                                        (context, String? valuePrice, child) {
                                      return DropdownButton<String>(
                                        focusNode: _dropFocus,
                                        onTap: () => _dropFocus.requestFocus(),
                                        key: GlobalKey(),
                                        value: _selectedPrice.value,
                                        //elevation: 5,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        items: getListPrices()
                                            .map<DropdownMenuItem<String>>(
                                                (String valueItem) {
                                          return DropdownMenuItem<String>(
                                            value: valueItem,
                                            child: Text(valueItem),
                                          );
                                        }).toList(),
                                        hint: const Text(
                                          "Elegir",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        onChanged: (String? price) {
                                          _selectedPrice.value = price;
                                        },
                                      );
                                    }),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                QuantitySelector(
                                  stock: int.parse(widget.product.stock),
                                  key: _quantitySelectorKey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "máx: " + widget.product.stock,
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                PrimaryButton(
                                  onTap: addProduct,
                                  title: Row(
                                    children: const [
                                      Text(
                                        "Añadir",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      MyIconAdd(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*ValueListenableBuilder(
                valueListenable: _productAdded,
                builder: (context, bool value, Widget? child) {
                  if (value) {
                    return Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: RoundedRemoveIconButton(
                            removeFunction: () {
                              _productAdded.value = false;
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                }),*/
          ],
        ),
      ),
    );
  }

  initProvider() {
    cartModelProvider = Provider.of<CartModel>(context, listen: false);
  }

  List<String> getListPrices() {
    List<String> prices = [];
    if (widget.product.price1 != null &&
        widget.product.price1 != "0" &&
        widget.product.price1!.isNotEmpty) {
      double price = double.parse(widget.product.price1!);
      String priceFixed = price.toStringAsFixed(2);
      prices.add(priceFixed);
    }

    if (widget.product.price2 != null &&
        widget.product.price2 != "0" &&
        widget.product.price2!.isNotEmpty) {
      double price = double.parse(widget.product.price2!);
      String priceFixed = price.toStringAsFixed(2);
      bool priceAdded = false;
      for (var e in prices) {
        if (e == priceFixed) {
          priceAdded = true;
        }
      }
      if (!priceAdded) {
        prices.add(priceFixed);
      }
    }

    if (widget.product.price3 != null &&
        widget.product.price3 != "0" &&
        widget.product.price3!.isNotEmpty) {
      double price = double.parse(widget.product.price3!);
      String priceFixed = price.toStringAsFixed(2);
      bool priceAdded = false;
      for (var e in prices) {
        if (e == priceFixed) {
          priceAdded = true;
        }
      }
      if (!priceAdded) {
        prices.add(priceFixed);
      }
    }

    if (widget.product.price4 != null &&
        widget.product.price4 != "0" &&
        widget.product.price4!.isNotEmpty) {
      double price = double.parse(widget.product.price4!);
      String priceFixed = price.toStringAsFixed(2);
      bool priceAdded = false;
      for (var e in prices) {
        if (e == priceFixed) {
          priceAdded = true;
        }
      }
      if (!priceAdded) {
        prices.add(priceFixed);
      }
    }

    // this price is to courtesy
    if (widget.product.price5 != null &&
        widget.product.price5 != "0" &&
        widget.product.price5!.isNotEmpty) {
      double price = double.parse(widget.product.price5!);
      String priceFixed = price.toStringAsFixed(2);
      bool priceAdded = false;
      for (var e in prices) {
        if (e == priceFixed) {
          priceAdded = true;
        }
      }
      if (!priceAdded) {
        prices.add("0");
      }
    }

    return prices;
  }

  void addProduct() {
    if (_selectedPrice.value != null) {
      int quantity = _quantitySelectorKey.currentState!.getQuantity();
      String warehouse = widget.warehouse;
      String code = widget.product.code;
      String image = widget.product.image;
      String description = widget.product.description;
      bool alreadyAdded = cartModelProvider.add(
        ProductSelected(_selectedPrice.value!, code, quantity.toString(),
            warehouse, image, description),
        (double.parse(_selectedPrice.value!) * quantity).toString(),
      );

      if (alreadyAdded) {
        Dialogs.informationDialog(context,
            title:
                "Ya existe este producto en el carrito, elimina el existente si deseas modificarlo");
      } else {
        //_productAdded.value = true;
        Dialogs.informationDialog(context, title: "Producto agregado");
      }
    } else {
      Dialogs.informationDialog(context,
          title: "Selecciona un precio para agregarlo");
    }
  }
}
