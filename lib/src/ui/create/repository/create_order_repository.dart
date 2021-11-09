import 'dart:convert';

import 'package:http/http.dart' show Response;
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_keys.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/models/product.dart';
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/network/base_response.dart';
import 'package:purchase_order/src/ui/create/models/product_group.dart';
import 'package:purchase_order/src/ui/create/models/warehouse.dart';
import 'package:purchase_order/src/ui/create/repository/create_order_routes.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';

class CreateOrderRepository {
  final ApiInstance? _apiInstance = ApiInstance.getInstance();

  Future<List<Warehouse>> getWarehouse() async {
    String? userString =
        await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);
    User userData = User.fromJson(jsonDecode(userString!));
    Uri url = _apiInstance!.concatURL(CreateOrderRoutes.getWarehouse);

    Response response = await _apiInstance!.client.post(url, body: {
      "user": userData.code,
    });

    switch (response.statusCode) {
      case 200:
        BaseResponse<Warehouse> baseResponse = BaseResponse.fromJson(
            jsonDecode(response.body), (json) => Warehouse.fromJson(json));
        List<Warehouse> warehousesList = baseResponse.data;
        return warehousesList;
      default:
        break;
    }

    return [];
  }

  Future<List<ProductGroup>> getProductGroup() async {
    Uri url = _apiInstance!.concatURL(CreateOrderRoutes.getGroups);

    Response response = await _apiInstance!.client.get(url);

    switch (response.statusCode) {
      case 200:
        BaseResponse<ProductGroup> baseResponse = BaseResponse.fromJson(
            jsonDecode(response.body), (json) => ProductGroup.fromJson(json));
        List<ProductGroup> productGroupList = baseResponse.data;
        return productGroupList;
      default:
        break;
    }

    return [];
  }

  Future<List<Product>> getProducts(
      String warehouse, String productGroup, String regexSearch) async {
    String? userString =
        await SharedPreferencesRepo.getPrefer(SharedPreferencesKeys.user);
    User userData = User.fromJson(jsonDecode(userString!));
    Uri url = _apiInstance!.concatURLParameters(CreateOrderRoutes.getProducts, {
      "grupo": productGroup,
      "bodega": warehouse,
      "descrip": regexSearch,
      "user": userData.code,
    });

    Response response = await _apiInstance!.client.get(url);

    switch (response.statusCode) {
      case 200:
        BaseResponse<Product> baseResponse = BaseResponse.fromJson(
            jsonDecode(response.body), (json) => Product.fromJson(json));
        List<Product> productList = baseResponse.data;
        return productList;
      default:
        break;
    }

    return [];
  }
}
