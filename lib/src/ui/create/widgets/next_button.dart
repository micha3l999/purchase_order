import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/dialogs.dart';

class NextButton extends StatefulWidget {
  const NextButton({Key? key}) : super(key: key);

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  late CartModel _cartModelProvider;

  @override
  void initState() {
    super.initState();
    _cartModelProvider = Provider.of<CartModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      onPressed: () {
        if (_cartModelProvider.products.isNotEmpty) {
          Navigator.pushNamed(context, Routes.clientPage);
        } else {
          Dialogs.informationDialog(context,
              title: "Agrega Productos al pedido");
        }
      },
      child: const MyIconNext(),
    );
  }
}
