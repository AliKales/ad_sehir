class ModelGameSettings {
  List<String>? categories;
  int? minute;

  ModelGameSettings({this.categories, this.minute});

  ModelGameSettings.fromJson(Map<String, dynamic> json) {
    categories = json['categories'].cast<String>();
    minute = json['minute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    data['minute'] = minute;
    return data;
  }
}
