import 'package:flutter/material.dart';

class FinalConsumerProvider extends ChangeNotifier {
  bool _consumerFinal = false;

  bool get consumerFinal => _consumerFinal;

  void changeConsumerFinal(bool value) {
    _consumerFinal = value;
    notifyListeners();
  }
}
