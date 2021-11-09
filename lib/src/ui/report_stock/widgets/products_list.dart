import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/products_report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/product_stock_card.dart';
import 'package:purchase_order/src/utils/colors.dart';
import 'package:purchase_order/src/utils/fonts.dart';

class ProductReportList extends StatelessWidget {
  const ProductReportList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productsStockList(context);
  }

  productsStockList(context) {
    if (!Provider.of<ReportProvider>(context).loading &&
        Provider.of<ProductsReportProvider>(context).productsReport != null) {
      if (Provider.of<ProductsReportProvider>(context)
          .productsReport!
          .isEmpty) {
        return Expanded(
          child: Center(
            child: Text(
              "No hay productos que mostrar",
              style: Fonts.title.copyWith(color: Colors.grey),
            ),
          ),
        );
      }
      return Expanded(
        child: productListBody(),
      );
    } else {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  productListBody() {
    return Consumer<ProductsReportProvider>(builder: (_, provider, child) {
      List<TableRow> reportList = [];
      reportList.add(
        TableRow(children: [
          Column(children: [
            Container(
              child: Text('Producto', style: TextStyle(fontSize: 14.0)),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            )
          ]),
          Column(children: [
            Container(
              child: Text('Stock', style: TextStyle(fontSize: 14.0)),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            )
          ]),
          Column(children: [
            Container(
              child: Text('VIP', style: TextStyle(fontSize: 14.0)),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            )
          ]),
          Column(children: [
            Container(
              child: Text('Pvp', style: TextStyle(fontSize: 14.0)),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            )
          ]),
          Column(children: [
            Container(
              child: Text('Tarj', style: TextStyle(fontSize: 14.0)),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            )
          ]),
          Column(children: [
            Container(
              child: Text('Dist', style: TextStyle(fontSize: 14.0)),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            )
          ]),
        ]),
      );
      for (int i = 0; i < provider.productsReport!.length; i++) {
        reportList.add(
          TableRow(children: [
            Column(children: [
              ProductStockCard(
                text: provider.productsReport![i].description,
              )
            ]),
            Column(children: [
              ProductStockCard(
                text: provider.productsReport![i].stock,
              )
            ]),
            Column(children: [
              ProductStockCard(
                text: provider.productsReport![i].price1,
                isPrice: true,
              )
            ]),
            Column(children: [
              ProductStockCard(
                text: provider.productsReport![i].price2,
                isPrice: true,
              )
            ]),
            Column(children: [
              ProductStockCard(
                text: provider.productsReport![i].price3,
                isPrice: true,
              )
            ]),
            Column(children: [
              ProductStockCard(
                text: provider.productsReport![i].price4,
                isPrice: true,
              )
            ]),
          ]),
        );
      }
      return ListView(children: [
        Container(
          color: whiteColor,
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2.1),
              1: FlexColumnWidth(1.1),
              2: FlexColumnWidth(1.45),
              3: FlexColumnWidth(1.45),
              4: FlexColumnWidth(1.45),
              5: FlexColumnWidth(1.45),
            },
            border: TableBorder.all(
                color: Colors.black26, style: BorderStyle.solid, width: 2),
            children: [
              ...reportList,
            ],
          ),
        )
      ]);
    });
    /*return ListView.separated(
      itemBuilder: (_, int count) => ProductStockCard(
          productReport: provider.productsReport![count]),
      separatorBuilder: (_, __) => const SizedBox(
        height: 2,
      ),
      itemCount: provider.productsReport?.length ?? 0,
    );*/
  }

  ///*return Container(
  //  child: Consumer<ProductsReportProvider>(
  //    builder: (_, provider, child) {
  //      return ListView.separated(
  //        itemBuilder: (_, int count) => ProductStockCard(
  //            productReport: provider.productsReport![count]),
  //        separatorBuilder: (_, __) => const SizedBox(
  //          height: 2,
  //        ),
  //        itemCount: provider.productsReport?.length ?? 0,
  //      );
  //    },
  //  ),
  //);/*
}
