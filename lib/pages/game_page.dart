import 'dart:async';

import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase/realtime.dart';
import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/pages/end_page.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> categories = Values.modelGameSettings?.categories ?? [];
  List<TextEditingController> listTECS = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Realtime().stopListeners();
    listTECS =
        List.generate(categories.length, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oyun"),
        backgroundColor: color1,
      ),
      backgroundColor: color1,
      body: body(),
    );
  }

  body() {
    ModelGameSettings gameSettings =
        Provider.of<ProviderGameSettings>(context).modelGameSetting;
    if (gameSettings.gameStatus == GameStatus.end) {
      List<String> _answers = List.generate(
          listTECS.length, (index) => listTECS[index].text.trim());

      WidgetsBinding.instance
          .addPostFrameCallback((_) => Funcs().navigatorPush(
              context,
              EndPage(
                answers: _answers,
              )));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline6!.copyWith(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const WidgetCounter(),
                Container(
                  decoration: const BoxDecoration(
                    color: color2,
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(categories[index]),
                            TextField(
                              controller: listTECS[index],
                              cursorColor: color1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: color1),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: color4,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetCounter extends StatefulWidget {
  const WidgetCounter({
    Key? key,
  }) : super(key: key);

  @override
  State<WidgetCounter> createState() => _WidgetCounterState();
}

class _WidgetCounterState extends State<WidgetCounter> {
  int counter = 0;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => start());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  start() {
    ModelGameSettings modelGameSettings =
        Values.modelGameSettings ?? ModelGameSettings();

    counter = modelGameSettings.dateTime!
        .difference(Funcs().getGMTDateTimeNow())
        .inSeconds;

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (counter == 0) {
          setState(() {
            timer.cancel();
          });
          if (Values().getIsLeader) {
            Realtime.endGame(context: context);
          }
        } else {
          setState(() {
            counter--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(counter.toString());
  }
}
