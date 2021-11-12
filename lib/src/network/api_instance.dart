import 'package:http/http.dart' show Client;
import 'package:purchase_order/src/network/api_base_routes.dart';

class ApiInstance {
  static late String _baseURL;

  // Url to print
  final String _printerURL = "http://192.168.3.10:9001/ImpresionTermica";
  final Client client = Client();

  static ApiInstance? _apiProviderImpl;

  ApiInstance(String baseUrl) {
    _baseURL = baseUrl;
  }

  static set baseURL(String value) {
    _baseURL = value;
  }

  static String get baseURL => _baseURL;

  static ApiInstance? getInstance([bool isRemote = false]) {
    if (_apiProviderImpl == null) {
      if (isRemote) {
        _apiProviderImpl = ApiInstance(ApiBaseRoutes.remoteUrl);
      } else {
        _apiProviderImpl = ApiInstance(ApiBaseRoutes.localUrl);
      }
    }
    return _apiProviderImpl;
  }

  Uri concatURL(String route) {
    return Uri.parse(_baseURL + route);
  }

  Uri concatURLParameters(String route, Map<String, String> parameters) {
    Uri url = Uri.http("", route, parameters);
    String subUrl = url.toString().substring(5);
    return Uri.parse(_baseURL + subUrl);
  }

  Uri concatURLPrinterParameters(String route, Map<String, String> parameters) {
    Uri url = Uri.http("", route, parameters);
    String subUrl = url.toString().substring(5);
    return Uri.parse(_printerURL + subUrl);
  }
}
