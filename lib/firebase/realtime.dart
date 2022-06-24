import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/models/model_player.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/provider/provider_room_page.dart';
import 'package:ad_sehir/values.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class Realtime {
  var ref = FirebaseDatabase.instanceFor(
          app: Firebase.apps[0],
          databaseURL:
              "https://isimsehir-1111-default-rtdb.europe-west1.firebasedatabase.app")
      .ref();

  static List listeners = [];

  static Future<String> createRoom(
      {context, required ModelGameSettings modelGameSettings}) async {
    DatabaseReference ref = Realtime().ref.child("rooms").push();

    await ref.set({
      'gameSettings': modelGameSettings.toJson(),
    });

    return ref.path.split("/").last;
  }

  static void startListeners({required context, required String roomId}) {
    Realtime().ref.child("rooms/$roomId/players").onChildAdded.listen((event) {
      ModelPlayer modelPlayer =
          ModelPlayer.fromJson(event.snapshot.value as Map<String, dynamic>);
      modelPlayer.id = event.snapshot.key;
      Provider.of<ProviderRoomPage>(context, listen: false)
          .addPlayer(modelPlayer);
    });

    Realtime()
        .ref
        .child("rooms/$roomId/players")
        .onChildRemoved
        .listen((event) {
      Provider.of<ProviderRoomPage>(context, listen: false)
          .removePlayer(event.snapshot.key ?? "");
    });

    Realtime().ref.child("rooms/$roomId/gameSettings").onValue.listen((event) {
      ModelGameSettings _mGS = ModelGameSettings.fromJson(
          event.snapshot.value as Map<String, dynamic>);
      Values.modelGameSettings = _mGS;
      Provider.of<ProviderGameSettings>(context, listen: false).update(_mGS);
    });
  }

  static Future joinToRoom(
      {required context,
      required String username,
      required String roomId}) async {
    var val = await Realtime().ref.child("rooms/$roomId/gameSettings").get();

    if (!val.exists) {
      Funcs().showSnackBar(context, "Bu oda bulunamadı!");
      return;
    }

    Values.modelGameSettings =
        ModelGameSettings.fromJson(val.value as Map<String, dynamic>);

    final String path = "rooms/$roomId/players/${Funcs().getIdByTime()}";

    Values.modelPlayerMe =
        ModelPlayer(username: username, id: path.split("/").last);

    Values.roomId = roomId;

    Realtime().ref.child(path).set(Values.modelPlayerMe!.toJson());

    Realtime().ref.child(path).onDisconnect().remove();
  }

  static Future startGame({required context, required String roomId}) async {
    final String path = "rooms/$roomId/gameSettings";
    ModelGameSettings modelGameSettings =
        Values.modelGameSettings ?? ModelGameSettings();
    modelGameSettings.gameStatus = GameStatus.game;
    int timeMinute = modelGameSettings.minute ?? 2;
    DateTime dateTime = Funcs().getGMTDateTimeNow();
    dateTime = dateTime.add(Duration(minutes: timeMinute));
    modelGameSettings.dateTime = dateTime;

    Values.modelGameSettings = modelGameSettings;
    Realtime().ref.child(path).update(modelGameSettings.toJson());
  }

  static Future endGame({required context}) async {
    final String path = "rooms/${Values.roomId}/gameSettings";
    ModelGameSettings modelGameSettings =
        Values.modelGameSettings ?? ModelGameSettings();

    modelGameSettings.gameStatus = GameStatus.end;
    Realtime().ref.child(path).update(modelGameSettings.toJson());
  }

  static Future uploadResults(
      {required context,
      required List<String> answers,
      required List<String> categories}) async {
    String path = "rooms/${Values().getRoomId}/results";

    ModelPlayer modelPlayerME = Values.modelPlayerMe!;

    Map<String, dynamic> resultsMap = {};

    List<ModelPlayer> players =
        Provider.of<ProviderRoomPage>(context, listen: false).players;

    players.removeWhere((element) => element.id == modelPlayerME.id);

    for (var category in categories) {
      for (var answer in answers) {
        resultsMap[category] = {
          modelPlayerME.id: {
            'username': modelPlayerME.username,
            'answer': answer,
            'ticks': players.map((e) => {e: true})
          }
        };
      }
      for (var player in players) {
        resultsMap[category][modelPlayerME.id]['ticks'] = {player.id: true};
      }
    }

    Realtime().ref.child(path).set(resultsMap);
  }
}
