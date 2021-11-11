import 'package:flutter/foundation.dart';

class LoginProvider extends ChangeNotifier {
  bool isRemote = false;

  void changeIsRemote() {
    isRemote = !isRemote;
    notifyListeners();
  }
}
