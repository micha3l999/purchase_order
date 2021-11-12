import 'dart:convert';

import 'package:http/http.dart' show Response;
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_keys.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/models/product_selected.dart';
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/network/base_response.dart';
import 'package:purchase_order/src/ui/client/models/client.dart';
import 'package:purchase_order/src/ui/client/models/create_client_response.dart';
import 'package:purchase_order/src/ui/client/models/create_order_response.dart';
import 'package:purchase_order/src/ui/client/repository/client_routes.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';

class ClientRepository {
  final ApiInstance? _apiInstance = ApiInstance.getInstance();

  Future<Client?> searchClient(String identification) async {
    Uri url = _apiInstance!.concatURLParameters(ClientRoutes.searchClient, {
      "identifica": identification,
    });

    Response response = await _apiInstance!.client.get(url);

    switch (response.statusCode) {
      case 200:
        BaseResponse<Client> baseResponse = BaseResponse.fromJson(
            jsonDecode(response.body), (json) => Client.fromJson(json));
        if (baseResponse.success == "1") {
          List<Client> clientList = baseResponse.data;
          return clientList[0];
        }
        break;
      default:
        break;
    }

    return null;
  }

  Future<CreateClientResponse?> createClient(
      Map<String, String> clientData) async {
    Uri url = _apiInstance!
        .concatURLParameters(ClientRoutes.createClient, clientData);

    Response response = await _apiInstance!.client.get(url);

    switch (response.statusCode) {
      case 200:
        BaseResponse<CreateClientResponse> baseResponse = BaseResponse.fromJson(
            jsonDecode(response.body),
            (json) => CreateClientResponse.fromJson(json));

        if (baseResponse.success == "1") {
          List<CreateClientResponse> createdClientList = baseResponse.data;
          return createdClientList[0];
        }
        break;
      default:
        break;
    }

    return null;
  }

  Future<CreateOrderResponse?> createPurchaseOrder(
      String clientCode, List<ProductSelected> productsSelected) async {
    String? userString =
        await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);
    User userData = User.fromJson(jsonDecode(userString!));

    List<Map<String, dynamic>> listProducts =
        productsSelected.map((e) => e.toJson()).toList();

    Uri url =
        _apiInstance!.concatURLParameters(ClientRoutes.createOrderPurchase, {
      "user": jsonEncode({
        "code": userData.code,
      }),
      "items": jsonEncode(listProducts),
      "client": jsonEncode({
        "code": clientCode,
      }),
    });

    try {
      Response response = await _apiInstance!.client.get(url);
      print(response.body);
      switch (response.statusCode) {
        case 200:
          BaseResponse<CreateOrderResponse> baseResponse =
              BaseResponse.fromJson(jsonDecode(response.body),
                  (json) => CreateOrderResponse.fromJson(json));

          if (baseResponse.success == "1") {
            List<CreateOrderResponse> createdClientList = baseResponse.data;
            return createdClientList[0];
          }
          break;
        default:
          break;
      }

      return null;
    } catch (error) {
      return null;
    }
  }

  Future<bool> printOrderTicker(String clientName,
      List<ProductSelected> products, String orderNumber) async {
    Uri url =
        _apiInstance!.concatURLPrinterParameters(ClientRoutes.printOrder, {
      "detalle": jsonEncode({
        "client": jsonEncode({
          "name": clientName,
        }),
        "items": jsonEncode(products),
        "order": orderNumber,
      }),
    });

    Response response = await _apiInstance!.client.get(url);

    switch (response.statusCode) {
      case 200:
        return true;
      default:
        break;
    }
    return false;
  }

  Future<CreateOrderResponse?> saveProforma(String clientCode,
      List<ProductSelected> productsSelected, String observation) async {
    String? userString =
        await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);
    User userData = User.fromJson(jsonDecode(userString!));

    List<Map<String, dynamic>> listProducts =
        productsSelected.map((e) => e.toJson()).toList();

    Uri url =
        _apiInstance!.concatURLParameters(ClientRoutes.createOrderPurchase, {
      "user": jsonEncode({
        "code": userData.code,
      }),
      "items": jsonEncode(listProducts),
      "client": jsonEncode({
        "code": clientCode,
      }),
      "op": jsonEncode({
        "code": "1",
      }),
      "observa": observation,
    });

    try {
      Response response = await _apiInstance!.client.get(url);

      switch (response.statusCode) {
        case 200:
          BaseResponse<CreateOrderResponse> baseResponse =
              BaseResponse.fromJson(jsonDecode(response.body),
                  (json) => CreateOrderResponse.fromJson(json));
          if (baseResponse.success == "1") {
            List<CreateOrderResponse> createdClientList = baseResponse.data;
            return createdClientList[0];
          }
          break;
        default:
          break;
      }

      return null;
    } catch (error) {
      return null;
    }
  }
}
