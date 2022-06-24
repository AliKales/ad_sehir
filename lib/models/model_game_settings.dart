import 'package:ad_sehir/values.dart';

class ModelGameSettings {
  List<String>? categories;
  int? minute;
  DateTime? dateTime;
  late GameStatus gameStatus;

  ModelGameSettings(
      {this.categories, this.minute, this.dateTime, this.gameStatus=GameStatus.lobby});

  ModelGameSettings.fromJson(Map<String, dynamic> json) {
    categories = json['categories'].cast<String>();
    minute = json['minute'];
    dateTime = DateTime.tryParse(json['dateTime']??"");
    gameStatus = GameStatus.values.byName(json['gameStatus']??"");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    data['minute'] = minute;
    data['dateTime'] = dateTime?.toIso8601String();
    data['gameStatus'] = gameStatus.name;
    return data;
  }
}
