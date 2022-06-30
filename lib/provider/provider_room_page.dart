import 'package:ad_sehir/models/model_player.dart';
import 'package:ad_sehir/values.dart';
import 'package:flutter/material.dart';

class ProviderRoomPage with ChangeNotifier {
  List<ModelPlayer> players = [];

  void addPlayer(ModelPlayer modelPlayer) {
    players.add(modelPlayer);
    Values.players = players;
    notifyListeners();
  }

  void removePlayer(String id) {
    players.removeWhere((element) => element.id == id);
    Values.players = players;
    notifyListeners();
  }
}
