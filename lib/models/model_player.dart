class ModelPlayer {
  String? username;
  String? id;

  ModelPlayer({this.username, this.id});

  ModelPlayer.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['id'] = id;
    return data;
  }
}
