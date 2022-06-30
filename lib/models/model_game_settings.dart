import 'package:ad_sehir/values.dart';

class ModelGameSettings {
  List<String>? categories;
  int? minute = 1;
  DateTime? dateTime;
  late GameStatus gameStatus;
  String? letter;

  ModelGameSettings(
      {this.categories, this.dateTime, this.gameStatus = GameStatus.lobby,this.letter});

  ModelGameSettings.fromJson(Map<String, dynamic> json) {
    categories = json['categories']?.cast<String>();
    minute = json['minute'];
    letter = json['letter'];
    dateTime = DateTime.tryParse(json['dateTime'] ?? "");
    gameStatus = GameStatus.values.byName(json['gameStatus'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    data['minute'] = minute;
    data['letter'] = letter;
    data['dateTime'] = dateTime?.toIso8601String();
    data['gameStatus'] = gameStatus.name;
    return data;
  }
}
