import 'dart:convert';

import 'package:http/http.dart' show Response;
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/network/base_response.dart';
import 'package:purchase_order/src/ui/create/models/warehouse.dart';
import 'package:purchase_order/src/ui/report_stock/models/product_report.dart';
import 'package:purchase_order/src/ui/report_stock/models/product_types.dart';
import 'package:purchase_order/src/ui/report_stock/repository/report_stock_routes.dart';

abstract class ReportStock {
  static final ApiInstance _apiInstance = ApiInstance.getInstance()!;

  // Get products Report types
  static Future<List<ProductTypes>?> getProductStockTypes() async {
    Uri url = _apiInstance.concatURL(ReportStockRoutes.productReportTypes);

    try {
      Response response = await _apiInstance.client.get(url);

      switch (response.statusCode) {
        case 200:
          BaseResponse<ProductTypes> baseResponse = BaseResponse.fromJson(
              jsonDecode(response.body), (json) => ProductTypes.fromJson(json));
          if (baseResponse.success == "1") {
            return baseResponse.data;
          }
          break;
        default:
          break;
      }
    } catch (error) {
      return null;
    }

    return null;
  }

  // Get products report with stock
  static Future<List<ProductReport>?> getProductsReport(
      String warehouse, String productType) async {
    Uri url =
        _apiInstance.concatURLParameters(ReportStockRoutes.reportOfProducts, {
      "bodega": warehouse,
      "tipo": productType,
    });

    try {
      Response response = await _apiInstance.client.get(url);

      switch (response.statusCode) {
        case 200:
          BaseResponse<ProductReport> baseResponse = BaseResponse.fromJson(
              jsonDecode(response.body),
              (json) => ProductReport.fromJson(json));
          if (baseResponse.success == "1") {
            return baseResponse.data;
          } else {
            return [];
          }
          break;
        default:
          break;
      }
    } catch (error) {
      return null;
    }

    return null;
  }

  // Get warehouses
  static Future<List<Warehouse>?> getWarehouses() async {
    Uri url = _apiInstance.concatURL(ReportStockRoutes.warehouses);

    try {
      Response response = await _apiInstance.client.get(url);

      switch (response.statusCode) {
        case 200:
          BaseResponse<Warehouse> baseResponse = BaseResponse.fromJson(
              jsonDecode(response.body), (json) => Warehouse.fromJson(json));
          if (baseResponse.success == "1") {
            return baseResponse.data;
          }
          break;
        default:
          break;
      }
    } catch (error) {
      return null;
    }

    return null;
  }
}
