import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/no_scroll_behavior.dart';
import 'package:purchase_order/src/models/user_instance.dart';
import 'package:purchase_order/src/routes/routes.dart';
import 'package:purchase_order/src/ui/create/provider/cart_model.dart';
import 'package:purchase_order/src/ui/create/view/create_page.dart';
import 'package:purchase_order/src/ui/manage_orders/view/manage_orders.dart';
import 'package:purchase_order/src/ui/past_orders/view/past_orders_page.dart';
import 'package:purchase_order/src/ui/report_stock/view/report_stock_view.dart';
import 'package:purchase_order/src/utils/colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _advancedDrawerController = AdvancedDrawerController();
  final UserInstance _user = UserInstance.getInstance();
  List<Widget> _optionMenu = [
    CreatePage(
      key: GlobalKey(),
    ),
    const ManageOrders(),
    const ReportStockView(),
    const PastOrdersPage(),
  ];
  final ValueNotifier<int> _selectedOptionChild = ValueNotifier(0);

  @override
  void dispose() {
    _selectedOptionChild.dispose();
    _advancedDrawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return AdvancedDrawer(
      backdropColor: Colors.grey.shade600,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Row(
            children: [
              const Text('XIAO'),
              const Spacer(),
              ValueListenableBuilder(
                  valueListenable: _selectedOptionChild,
                  builder: (context, value, child) {
                    if (_selectedOptionChild.value == 0) {
                      return IconButton(
                        onPressed: () async {
                          await Navigator.of(context)
                              .pushNamed(Routes.cartPage);
                          _optionMenu = [
                            CreatePage(
                              key: GlobalKey(),
                            ),
                            const ManageOrders(),
                            const ReportStockView(),
                            const PastOrdersPage(),
                          ];
                          setState(() {});
                          //_selectedOptionChild.notifyListeners();
                        },
                        icon: Consumer<CartModel>(
                            builder: (context, cart, child) {
                          return MyIconCart(
                            cartNumber: cart.products.length,
                          );
                        }),
                      );
                    }

                    return Container();
                  })
            ],
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: _selectedOptionChild,
          builder: (_, int value, child) {
            return _optionMenu[value];
          },
        ),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: ScrollConfiguration(
            behavior: NoScrollBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 138,
                    height: 128.0,
                    margin: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 14.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                    ),
                    child: Container(
                      width: 158,
                      child: Image(
                        image: Image.asset(
                          'assets/images/xiao_logo.jpg',
                        ).image,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Usuario: ${_user.name}",
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.only(bottom: 35),
                  ),
                  ListTile(
                    onTap: () {
                      if (_selectedOptionChild.value == 0) {
                        _advancedDrawerController.value =
                            AdvancedDrawerValue.hidden();
                      } else {
                        _selectedOptionChild.value = 0;
                        _advancedDrawerController.value =
                            AdvancedDrawerValue.hidden();
                      }
                    },
                    leading: const Icon(Icons.note_add_outlined),
                    title: const Text('Crear nota de pedido'),
                  ),
                  ListTile(
                    onTap: () {
                      _selectedOptionChild.value = 1;
                      _advancedDrawerController.value =
                          AdvancedDrawerValue.hidden();
                    },
                    leading: const Icon(Icons.sticky_note_2_outlined),
                    title: const Text('Maneja orden/proforma'),
                  ),
                  ListTile(
                    onTap: () {
                      _selectedOptionChild.value = 2;
                      _advancedDrawerController.value =
                          AdvancedDrawerValue.hidden();
                    },
                    leading: const Icon(Icons.desktop_windows),
                    title: const Text('Stock Producto'),
                  ),
                  ListTile(
                    onTap: () {
                      _selectedOptionChild.value = 3;
                      _advancedDrawerController.value =
                          AdvancedDrawerValue.hidden();
                    },
                    leading: const Icon(Icons.date_range_outlined),
                    title: const Text('Lista de ventas'),
                  ),
                  SizedBox(
                    height: (height - 555).isNegative ? 0 : (height - 555),
                  ),
                  GestureDetector(
                    onTap: () {
                      SharedPreferencesRepo.clearPrefer();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.login, (Route<dynamic> route) => false);
                    },
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            MyIconLogout(),
                            SizedBox(width: 5),
                            Text('Cerrar sesión'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
