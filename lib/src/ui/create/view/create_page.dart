import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/product_card.dart';
import 'package:purchase_order/src/global_widgets/search_bar.dart';
import 'package:purchase_order/src/models/product.dart';
import 'package:purchase_order/src/ui/create/models/product_group.dart';
import 'package:purchase_order/src/ui/create/models/warehouse.dart';
import 'package:purchase_order/src/ui/create/repository/create_order_repository.dart';
import 'package:purchase_order/src/ui/create/widgets/next_button.dart';
import 'package:purchase_order/src/ui/create/widgets/no_products.dart';
import 'package:purchase_order/src/ui/create/widgets/product_list_shimmer.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';
import 'package:purchase_order/src/utils/global_functions.dart';
import 'package:shimmer/shimmer.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final CreateOrderRepository _repository = CreateOrderRepository();
  List<Warehouse> _warehouses = [];
  List<ProductGroup> _productGroups = [];
  List<Product>? _products;

  late ValueNotifier<Warehouse> _selectedWarehouse;
  final ValueNotifier<ProductGroup?> _selectedGroup = ValueNotifier(null);
  final ValueNotifier<bool?> _updateProducts = ValueNotifier(null);
  String? _regexSearch = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedWarehouse.dispose();
    _selectedGroup.dispose();
    _updateProducts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: const NextButton(),
      body: SafeArea(
          child: Container(
        color: greyColorLight,
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.normalPadding),
          child: loadPage(width, height),
        ),
      )),
    );
  }

  Widget optionRowWarehouse(double height, double width) {
    return SizedBox(
      height: 34,
      width: width,
      child: ListView.separated(
        separatorBuilder: (_, int count) => const SizedBox(
          width: 8,
        ),
        itemBuilder: (_, int count) {
          return optionFilterWarehouse(_warehouses[count]);
        },
        itemCount: _warehouses.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget optionRowCategory(double height, double width) {
    return SizedBox(
      height: 34,
      width: width,
      child: ListView.separated(
        separatorBuilder: (_, int count) => const SizedBox(
          width: 8,
        ),
        itemBuilder: (_, int count) {
          return optionFilterGroup(_productGroups[count]);
        },
        itemCount: _productGroups.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget optionFilterWarehouse(Warehouse option) {
    return InkWell(
      onTap: () {
        _selectedWarehouse.value = option;
        _updateProducts.notifyListeners();
      },
      child: ValueListenableBuilder(
          valueListenable: _selectedWarehouse,
          builder: (context, data, widget) {
            return SizedBox(
              height: 30,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: option.code == _selectedWarehouse.value.code
                    ? primaryColor
                    : Colors.white,
                elevation: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Text(
                      option.description,
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: option.code == _selectedWarehouse.value.code
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget optionFilterGroup(ProductGroup option) {
    return InkWell(
      onTap: () {
        if (_selectedGroup.value == option) {
          _selectedGroup.value = null;
          _updateProducts.notifyListeners();
        } else {
          _selectedGroup.value = option;
          _updateProducts.notifyListeners();
        }
      },
      child: ValueListenableBuilder(
          valueListenable: _selectedGroup,
          builder: (context, data, widget) {
            return SizedBox(
              height: 30,
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: _selectedGroup.value?.code == option.code
                    ? primaryColor
                    : Colors.white,
                elevation: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Text(
                      option.description,
                      style: GoogleFonts.lato(
                          fontSize: 14,
                          color: _selectedGroup.value != null &&
                                  option.code == _selectedGroup.value?.code
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget productList() {
    return ValueListenableBuilder(
        valueListenable: _updateProducts,
        builder: (context, value, child) {
          return FutureBuilder<List<Product>>(
            future: _repository.getProducts(_selectedWarehouse.value.code,
                _selectedGroup.value?.code ?? "", _regexSearch ?? ""),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _products = snapshot.data;

                if (_products?.isEmpty ?? true) {
                  return const NoProducts();
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  separatorBuilder: GlobalFunctions.noVerticalSeparator,
                  itemBuilder: (_, int count) => ProductCard(
                    warehouse: _selectedWarehouse.value.code,
                    product: _products![count],
                    key: GlobalKey(),
                    lastItem: checkLastItemProduct(count),
                  ),
                  itemCount: _products!.length,
                );
              }

              return const ProductListShimmer();
            },
          );
        });
  }

  // Check if it's the last item of the product list to add bottom padding
  bool checkLastItemProduct(int count) {
    return (count + 1) == _products!.length;
  }

  Widget loadPage(double width, double height) {
    return FutureBuilder(
      future: getFutures(),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          List<dynamic> data = snapshot.data!;
          _warehouses = data[0];
          _selectedWarehouse = ValueNotifier(_warehouses[0]);
          _productGroups = data[1];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 26,
                width: width,
                child: Center(
                  child: Text(
                    "Crear Orden de Compra",
                    style: Fonts.bigTitle,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Row(
                      children: [
                        const MyIconHouse(),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Bodegas",
                          style: Fonts.regular.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  optionRowWarehouse(height, width),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Row(
                      children: [
                        const MyIconCategories(),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Categorías",
                          style: Fonts.regular.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  optionRowCategory(height, width),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: Row(
                  children: [
                    const MyIconShoppingCart(),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Productos",
                      style: Fonts.regular.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SearchBar(
                searchFunction: (String value) {
                  _regexSearch = value;
                  _updateProducts.notifyListeners();
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(child: productList()),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 26,
              width: width,
              child: Center(
                child: Text(
                  "Crear Orden de Compra",
                  style: Fonts.bigTitle,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.other_houses_outlined),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Bodegas",
                        style: Fonts.regular.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: width,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: ListView.separated(
                      separatorBuilder: (_, int count) => const SizedBox(
                        width: 8,
                      ),
                      itemBuilder: (_, int count) => Container(
                        height: 15,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey),
                      ),
                      itemCount: 9,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Row(
                    children: [
                      const MyIconCategories(),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Categorías",
                        style: Fonts.regular.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: width,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: ListView.separated(
                      separatorBuilder: (_, int count) => const SizedBox(
                        width: 8,
                      ),
                      itemBuilder: (_, int count) => Container(
                        height: 15,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey),
                      ),
                      itemCount: 9,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              child: Row(
                children: [
                  const MyIconShoppingCart(),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Productos",
                    style: Fonts.regular.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            SearchBar(
              searchFunction: (String value) {},
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(child: ProductListShimmer()),
          ],
        );
      },
    );
  }

  Future<List<dynamic>> getFutures() async {
    List<List<dynamic>> futures = await Future.wait([
      _repository.getWarehouse(),
      _repository.getProductGroup(),
    ]);

    return futures;
  }
}
