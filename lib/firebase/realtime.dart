import 'dart:async';
import 'dart:math';

import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/models/model_player.dart';
import 'package:ad_sehir/provider/provider_end_page.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/provider/provider_room_page.dart';
import 'package:ad_sehir/values.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

class Realtime {
  static StreamSubscription? streamSubscription1;
  static StreamSubscription? streamSubscription2;

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
    streamSubscription1 = Realtime()
        .ref
        .child("rooms/$roomId/players")
        .onChildAdded
        .listen((event) {
      ModelPlayer modelPlayer =
          ModelPlayer.fromJson(event.snapshot.value as Map<String, dynamic>);
      modelPlayer.id = event.snapshot.key;
      Provider.of<ProviderRoomPage>(context, listen: false)
          .addPlayer(modelPlayer);
    });

    streamSubscription2 = Realtime()
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

  void stopListeners() {
    streamSubscription1?.cancel();
    streamSubscription2?.cancel();
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
    ModelPlayer modelPlayerME = Values.modelPlayerMe!;

    String path = "rooms/${Values().getRoomId}/results/${modelPlayerME.id}";

    Map<String, dynamic> resultsMap = {};

    List<ModelPlayer> players =
        Provider.of<ProviderRoomPage>(context, listen: false).players;

    players.removeWhere((element) => element.id == modelPlayerME.id);

    for (var i = 0; i < categories.length; i++) {
      String answ = answers[i].trim();
      if (answ == "") answ = "---";
      Map<String, dynamic> ticksMap = {};
      for (var element in players) {
        ticksMap["${element.id}|${element.username}"] = true;
      }
      resultsMap[categories[i]] = {
        'username': modelPlayerME.username,
        'answer': answ,
        'ticks': ticksMap
      };
    }

    Realtime().ref.child(path).update(resultsMap);
  }

  static void listenToResults({required context}) {
    String path = "rooms/${Values().getRoomId}/results";
    Realtime().ref.child(path).onChildAdded.listen((event) {
      Provider.of<ProviderEndPage>(context, listen: false)
          .update(event.snapshot.key ?? "", event.snapshot.value ?? "");
    });

    Realtime().ref.child(path).onChildChanged.listen((event) {
      Provider.of<ProviderEndPage>(context, listen: false)
          .update(event.snapshot.key ?? "", event.snapshot.value ?? "");
    });
  }

  static Future changeTick(
      {required context,
      required String userId,
      required String category,
      required bool value}) async {
    String path = "rooms/${Values().getRoomId}/results/$userId/$category/ticks";
    Realtime().ref.child(path).update({
      "${Values().getModelPlayerMe?.id}|${Values().getModelPlayerMe?.username}":
          value
    });
  }
}
