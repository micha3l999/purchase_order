import 'dart:convert';

import 'package:http/http.dart' show Response;
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_keys.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/network/base_response.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';
import 'package:purchase_order/src/ui/manage_orders/models/order_details.dart';
import 'package:purchase_order/src/ui/manage_orders/models/orders_pending.dart';
import 'package:purchase_order/src/ui/manage_orders/repository/manage_orders_routes.dart';

abstract class ManageOrdersRepository {
  static final ApiInstance _apiInstance = ApiInstance.getInstance()!;

  static Future<List<OrdersPending>?> getOrdersPending() async {
    try {
      String? user =
          await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);

      User userInstance;

      if (user != null) {
        userInstance = User.fromJson(jsonDecode(user));
      } else {
        return null;
      }

      final url = _apiInstance.concatURLParameters(
          ManageOrdersRoutes.enlistPendingOrders, {"user": userInstance.code});

      Response response = await _apiInstance.client.get(url);
      switch (response.statusCode) {
        case 200:
          BaseResponse<OrdersPending> baseResponse = BaseResponse.fromJson(
              jsonDecode(response.body),
              (json) => OrdersPending.fromJson(json));

          return baseResponse.data;
        default:
          return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<OrderDetails?> getOrdersDetails(
      String type, String orderCode) async {
    try {
      String? user =
          await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);

      User userInstance;

      if (user != null) {
        userInstance = User.fromJson(jsonDecode(user));
      } else {
        return null;
      }

      final url = _apiInstance
          .concatURLParameters(ManageOrdersRoutes.deleteApplyOrders, {
        "user": userInstance.code,
        "op": "3",
        "tipo": type,
        "codigo": orderCode,
      });

      Response response = await _apiInstance.client.get(url);
      switch (response.statusCode) {
        case 200:
          BaseResponse<OrderDetails> baseResponse = BaseResponse.fromJson(
              jsonDecode(response.body), (json) => OrderDetails.fromJson(json));

          return baseResponse.data[0];
        default:
          return null;
      }
    } catch (error) {
      return null;
    }
  }

  static Future<bool> deletePendingOrder(String type, String orderCode) async {
    try {
      String? user =
          await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);

      User userInstance;

      if (user != null) {
        userInstance = User.fromJson(jsonDecode(user));
      } else {
        return false;
      }

      final url = _apiInstance
          .concatURLParameters(ManageOrdersRoutes.deleteApplyOrders, {
        "user": userInstance.code,
        "op": "1",
        "tipo": type,
        "codigo": orderCode,
      });

      Response response = await _apiInstance.client.get(url);
      switch (response.statusCode) {
        case 200:
          Map responseMap = jsonDecode(response.body);
          if (responseMap["success"] == "1") {
            return true;
          } else {
            return false;
          }
        default:
          return false;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<bool> applyProforma(String orderCode) async {
    try {
      String? user =
          await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);

      User userInstance;

      if (user != null) {
        userInstance = User.fromJson(jsonDecode(user));
      } else {
        return false;
      }

      final url = _apiInstance
          .concatURLParameters(ManageOrdersRoutes.deleteApplyOrders, {
        "user": userInstance.code,
        "op": "2",
        "tipo": "PROFORMA",
        "codigo": orderCode,
      });

      Response response = await _apiInstance.client.get(url);
      switch (response.statusCode) {
        case 200:
          Map responseMap = jsonDecode(response.body);
          if (responseMap["success"] == "1") {
            return true;
          } else {
            return false;
          }
        default:
          return false;
      }
    } catch (error) {
      return false;
    }
  }
}
