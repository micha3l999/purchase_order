import 'dart:convert';

import 'package:http/http.dart' show Response;
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_keys.dart';
import 'package:purchase_order/src/dependencies/shared_preferences/shared_preferences_repo.dart';
import 'package:purchase_order/src/models/user_instance.dart';
import 'package:purchase_order/src/network/api_instance.dart';
import 'package:purchase_order/src/network/base_response.dart';
import 'package:purchase_order/src/ui/login/models/user.dart';
import 'package:purchase_order/src/ui/login/repository/login_routes.dart';

class LoginRepository {
  final ApiInstance? _apiInstance = ApiInstance.getInstance();

  Future<Map> signIn(String? username, String? password) async {
    Uri url = _apiInstance!.concatURL(LoginRoutes.login);

    try {
      Response response = await _apiInstance!.client.post(
        url,
        body: {
          "user": username,
          "pass": password,
        },
      );

      switch (response.statusCode) {
        case 200:
          BaseResponse<User> result = BaseResponse<User>.fromJson(
              jsonDecode(response.body), (data) => User.fromJson(data));

          if (result.success == "1") {
            User user = result.data[0];

            SharedPreferencesRepo.setPrefer(
                SharedPreferencesKeys.user, jsonEncode(user));
            UserInstance.getInstance(user.name, user.code);

            return {
              "user": user,
              "result": "CONNECTED",
            };
          }
          break;
        default:
          break;
      }
    } catch (error) {
      return {
        "user": null,
        "result": "CONNECTION",
      };
    }

    return {
      "user": null,
      "result": "PASSWORD",
    };
  }
}
