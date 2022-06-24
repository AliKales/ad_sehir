import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/models/model_player.dart';

class Values {
  static ModelPlayer? modelPlayerMe;
  static ModelGameSettings? modelGameSettings;
  static String roomId = "";
  static bool isLeader = false;

  bool get getIsLeader => isLeader;
  String get getRoomId => roomId;
  ModelPlayer? get getModelPlayerMe => modelPlayerMe;
  ModelGameSettings? get getModelGameSettings => modelGameSettings;
}

enum GameStatus {
  lobby,
  game,
  end,
}
