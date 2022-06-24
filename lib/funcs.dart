import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/models/model_player.dart';
import 'package:ad_sehir/values.dart';
import 'package:flutter/material.dart';

class Funcs {
  Future<dynamic> navigatorPush(context, page) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    var object = await Navigator.push(context, route);
    return object;
  }

  void navigatorPushReplacement(context, page) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.pushReplacement(context, route);
  }

  void showSnackBar(context, String text) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: color4),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: color3,
      ),
    );
  }

  DateTime getGMTDateTimeNow() {
    int iS = DateTime.now().timeZoneOffset.inSeconds;
    return DateTime.now().subtract(Duration(seconds: iS));
  }

  DateTime? getFixedDateTime(DateTime? dT) {
    int iS = DateTime.now().timeZoneOffset.inSeconds;
    return dT?.add(Duration(seconds: iS));
  }

  String getIdByTime() {
    DateTime dateTime = getGMTDateTimeNow();
    return "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}${dateTime.millisecond}";
  }

  bool hasJoined(players) {
    return players
            .firstWhere(
              (element) => element.id == Values.modelPlayerMe?.id,
              orElse: () => ModelPlayer(),
            )
            .id ==
        null;
  }
}
