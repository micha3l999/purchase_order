import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchase_order/src/global_widgets/my_icons.dart';
import 'package:purchase_order/src/global_widgets/primary_button.dart';
import 'package:purchase_order/src/ui/past_orders/models/past_sale.dart';
import 'package:purchase_order/src/ui/past_orders/repository/past_sale_repository.dart';
import 'package:purchase_order/src/ui/past_orders/widgets/sale_card.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/dialogs.dart';
import 'package:purchase_order/src/utils/dimensions.dart';
import 'package:purchase_order/src/utils/fonts.dart';
import 'package:purchase_order/src/utils/global_functions.dart';

class PastOrdersPage extends StatefulWidget {
  const PastOrdersPage({Key? key}) : super(key: key);

  @override
  _PastOrdersPageState createState() => _PastOrdersPageState();
}

class _PastOrdersPageState extends State<PastOrdersPage> {
  final ValueNotifier<DateTime> _selectedDateIni =
      ValueNotifier(DateTime.now().add(const Duration(days: -31)));
  final ValueNotifier<DateTime> _selectedDateFin =
      ValueNotifier(DateTime.now());
  final ValueNotifier<List<PastSale>?> _pastSales = ValueNotifier(null);
  double _totalSale = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(Dimensions.normalPadding,
            Dimensions.normalPadding, Dimensions.normalPadding, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  child: Text(
                    "Lista de ventas",
                    style: Fonts.bigTitle,
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    child: PrimaryButton(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Buscar"),
                            SizedBox(
                              width: 5,
                            ),
                            MyIconSearch(),
                          ],
                        ),
                        onTap: onSearchFunction),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _selectedDateIni.value = DateTime.now();
                      showDatePicker(_selectedDateIni);
                    },
                    child: Column(
                      children: [
                        Text("Fecha inicio: ", style: Fonts.title),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _selectedDateIni,
                              builder: (_, DateTime? value, __) {
                                return value != null
                                    ? Text(formatDate(value) + " ")
                                    : Text("");
                              },
                            ),
                            const MyIconDate(),
                            const Icon(Icons.arrow_drop_down_outlined),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _selectedDateFin.value = DateTime.now();

                      showDatePicker(_selectedDateFin);
                    },
                    child: Column(
                      children: [
                        Text("Fecha fin: ", style: Fonts.title),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _selectedDateFin,
                              builder: (_, DateTime? value, child) {
                                return value != null
                                    ? Text(formatDate(value) + " ")
                                    : const Text("");
                              },
                            ),
                            const MyIconDate(),
                            const Icon(Icons.arrow_drop_down_outlined),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: listPastSales(),
            ),
          ],
        ),
      ),
    );
  }

  void showDatePicker(ValueNotifier<DateTime?> date) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                if (value != date.value) {
                  date.value = value;
                }
              },
              initialDateTime: DateTime.now(),
            ),
          );
        });
  }

  Future<void> onSearchFunction() async {
    if (_selectedDateFin.value.isBefore(_selectedDateIni.value)) {
      Dialogs.informationDialog(context,
          title: "La fecha de fin debe de ser mayor que la de inicio");
    } else {
      _pastSales.value = await PastSaleRepository.getPastSales(
          formatDate(_selectedDateIni.value),
          formatDate(_selectedDateFin.value));
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  listPastSales() {
    return ValueListenableBuilder(
        valueListenable: _pastSales,
        builder: (_, List<PastSale>? sales, __) {
          if (sales == null) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "Empieza a buscar...",
                  textAlign: TextAlign.center,
                  style: Fonts.normal,
                ),
              ),
            );
          } else if (sales.isEmpty) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "No hay ventas en el período establecido",
                  textAlign: TextAlign.center,
                  style: Fonts.normal,
                ),
              ),
            );
          } else {
            _totalSale = 0;
            sales.map((e) {
              _totalSale = _totalSale + double.parse(e.total);
            }).toList();
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: ListView.separated(
                    itemBuilder: (_, int count) =>
                        SaleCard(sale: _pastSales.value![count]),
                    separatorBuilder: (_, __) =>
                        GlobalFunctions.getVerticalSeparator(_, __),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _pastSales.value!.length,
                  ),
                ),
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
                          padding:
                              const EdgeInsets.all(Dimensions.normalPadding),
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
                                            _totalSale.toStringAsFixed(2),
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
          }
        });
  }
}
