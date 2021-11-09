import 'package:http/http.dart' show Client;

class ApiInstance {
  //final String _baseURL = "http://190.110.52.182:9001/webservice";
  final String _baseURL = "http://192.168.3.10/webservice";
  final String _printerURL = "http://192.168.3.10:9001/ImpresionTermica";
  final Client client = Client();

  static ApiInstance? _apiProviderImpl;

  static ApiInstance? getInstance() {
    if (_apiProviderImpl == null) return ApiInstance();
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
