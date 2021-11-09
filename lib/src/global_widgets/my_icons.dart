import 'package:flutter/material.dart';
import 'package:purchase_order/src/utils/colors.dart';

class MyIconShoppingCart extends StatelessWidget {
  const MyIconShoppingCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.shopping_cart_outlined,
    );
  }
}

class MyIconCategories extends StatelessWidget {
  const MyIconCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.category_outlined);
  }
}

class MyIconAdd extends StatelessWidget {
  const MyIconAdd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.add_shopping_cart_outlined,
      size: 14,
    );
  }
}

class MyIconNext extends StatelessWidget {
  const MyIconNext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.navigate_next);
  }
}

class MyIconCart extends StatelessWidget {
  const MyIconCart({Key? key, this.cartNumber = 0}) : super(key: key);

  final int cartNumber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(Icons.shopping_cart_outlined),
        cartNumber != 0
            ? Container(
                alignment: Alignment.topRight,
                child: Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    cartNumber.toString(),
                    style: const TextStyle(fontSize: 10, color: primaryColor),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class MyIconRemove extends StatelessWidget {
  const MyIconRemove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.remove_circle,
      color: Colors.red.shade800,
    );
  }
}

class MyIconEmpty extends StatelessWidget {
  const MyIconEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.remove_shopping_cart_outlined,
      size: 44,
      color: Colors.grey,
    );
  }
}

class MyIconLogout extends StatelessWidget {
  const MyIconLogout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.logout,
      size: 20,
      color: Colors.grey,
    );
  }
}

class MyIconProforma extends StatelessWidget {
  const MyIconProforma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.sticky_note_2_rounded,
      size: 20,
    );
  }
}

class MyIconPerson extends StatelessWidget {
  const MyIconPerson({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.account_circle_rounded,
      color: Colors.grey.shade700,
    );
  }
}

class MyIconHouse extends StatelessWidget {
  const MyIconHouse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.other_houses_outlined);
  }
}

class MyIconInformationOrder extends StatelessWidget {
  const MyIconInformationOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.info,
      size: 18,
    );
  }
}

class MyIconApplyProforma extends StatelessWidget {
  const MyIconApplyProforma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.assignment,
      size: 18,
    );
  }
}
