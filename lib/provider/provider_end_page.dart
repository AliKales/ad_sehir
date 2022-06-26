import 'package:flutter/material.dart';

class ProviderEndPage with ChangeNotifier {
  Map results = {};

  void update(String key, dynamic value) {
    results[key] = value;
    notifyListeners();
  }
}
