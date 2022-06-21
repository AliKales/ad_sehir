import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:flutter/material.dart';

class ProviderGameSettings with ChangeNotifier {
  ModelGameSettings modelGameSetting = ModelGameSettings();

  void update(ModelGameSettings value) {
    modelGameSetting = value;
    notifyListeners();
  }
}
