import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/report_provider.dart';
import 'package:purchase_order/src/ui/report_stock/provider/warehouse_selected.dart';
import 'package:purchase_order/src/ui/report_stock/widgets/warehouse_option.dart';
import 'package:shimmer/shimmer.dart';

class WarehousesList extends StatefulWidget {
  const WarehousesList({Key? key}) : super(key: key);

  @override
  State<WarehousesList> createState() => _WarehousesListState();
}

class _WarehousesListState extends State<WarehousesList> {
  late ReportProvider _reportProvider;
  late WarehouseSelectedProvider _warehouseSelectedProvider;

  @override
  void initState() {
    super.initState();

    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    _warehouseSelectedProvider =
        Provider.of<WarehouseSelectedProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<ReportProvider>(context).loading &&
        Provider.of<ReportProvider>(context)
            .warehousesProvider
            .warehousesList!
            .isNotEmpty) {
      return warehouseList();
    } else {
      return Container(
        child: warehouseShimmer(),
      );
    }
  }

  warehouseShimmer() {
    return SizedBox(
      height: 43,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: ListView.separated(
          separatorBuilder: (_, int count) => const SizedBox(
            width: 8,
          ),
          itemBuilder: (_, int count) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              height: 15,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.grey),
            ),
          ),
          itemCount: 9,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  warehouseList() {
    _warehouseSelectedProvider.warehouseSelected =
        _reportProvider.warehousesProvider.warehousesList![0];
    return SizedBox(
      height: 52,
      child: ListView.separated(
        separatorBuilder: (_, int count) => const SizedBox(
          width: 8,
        ),
        itemBuilder: (_, int count) {
          return WarehouseOption(
              warehouse:
                  _reportProvider.warehousesProvider.warehousesList![count]);
        },
        itemCount:
            _reportProvider.warehousesProvider.warehousesList?.length ?? 0,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
