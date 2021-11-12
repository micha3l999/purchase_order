import 'dart:convert';

import 'package:http/http.dart' show Response;
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_keys.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/network/base_response.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';
import 'package:purchase_order/src/ui/past_orders/models/past_sale.dart';
import 'package:purchase_order/src/ui/past_orders/repository/past_sale_routes.dart';

abstract class PastSaleRepository {
  static final ApiInstance _apiInstance = ApiInstance.getInstance()!;

  static Future<List<PastSale>?> getPastSales(
      String dateFrom, String dateFinal) async {
    try {
      String? user =
          await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);

      User userInstance;

      if (user != null) {
        userInstance = User.fromJson(jsonDecode(user));
      } else {
        return null;
      }

      final url = _apiInstance.concatURLParameters(PastSaleRoutes.saleList, {
        "user": userInstance.code,
        "fecha_ini": dateFrom,
        "fecha_fin": dateFinal
      });

      Response response = await _apiInstance.client.get(url);
      switch (response.statusCode) {
        case 200:
          BaseResponse<PastSale> baseResponse = BaseResponse.fromJson(
              jsonDecode(response.body), (json) => PastSale.fromJson(json));

          return baseResponse.data;
        default:
          return null;
      }
    } catch (error) {
      return null;
    }
  }
}
