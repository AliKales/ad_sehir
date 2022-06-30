import 'dart:async';

import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase/realtime.dart';
import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/simpleUIs.dart';
import 'package:ad_sehir/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.roomId}) : super(key: key);
  final String roomId;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<String> categories = Values.modelGameSettings?.categories ?? [];

  List<TextEditingController> listTECS = List.generate(
      Values().getModelGameSettings?.categories?.length ?? 0,
      (index) => TextEditingController());

  List<String> answers = [];
  Function eq = const ListEquality().equals;
  bool isAnswersUploaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listTECS =
        List.generate(categories.length, (index) => TextEditingController());

    Realtime().listenToGameSettings(context, Values().getRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oyun"),
        backgroundColor: color1,
        leading: const SizedBox.shrink(),
      ),
      backgroundColor: color1,
      body: body(),
    );
  }

  body() {
    ModelGameSettings gameSettings =
        Provider.of<ProviderGameSettings>(context).modelGameSetting;

    if (gameSettings.gameStatus == GameStatus.end) {
      if (isAnswersUploaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, "/end?r=${widget.roomId}");
        });
      } else {
        //Realtime().endSB3();

        List<String> _answers = getAnswers();

        Realtime.uploadResults(
                context: context, answers: _answers, categories: categories)
            .then((value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, "/end?r=${widget.roomId}");
          });
        });
      }
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: WidgetCounter(),
                ),
                Text("Harf: ${gameSettings.letter}"),
                const Divider(),
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
                            Text(categories[index]
                                .toString()
                                .replaceAll("aynisinemalar", "")),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: TextField(
                                onChanged: (value) {
                                  if (value.length == 1 &&
                                      !gameSettings.letter!
                                          .toLowerCase()
                                          .contains(value.toLowerCase())) {
                                    listTECS[index].clear();
                                  }
                                },
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
                const SizedBox(
                  height: 20,
                ),
                SimpleUIs.elevatedButton(
                    context: context,
                    onPress: () {
                      List<String> _answers = getAnswers();
                      if (eq(_answers, answers)) {
                        Funcs().showSnackBar(
                            context, "Aynı cevaplar zaten yüklendi!");
                      } else {
                        answers = _answers.toList();

                        Realtime.uploadResults(
                                context: context,
                                answers: answers,
                                categories:
                                    Values().getModelGameSettings!.categories!)
                            .then((value) {
                          Realtime.finishGame(context: context);
                          isAnswersUploaded = true;
                          Funcs().showSnackBar(context, "Cevaplar yüklendi!");
                        });
                      }
                    },
                    text: "Bitir"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> getAnswers() =>
      List.generate(listTECS.length, (index) => listTECS[index].text.trim());
}

class WidgetCounter extends StatefulWidget {
  const WidgetCounter({Key? key}) : super(key: key);

  @override
  State<WidgetCounter> createState() => _WidgetCounterState();
}

class _WidgetCounterState extends State<WidgetCounter> {
  int counter = -1;
  Timer? _timer;
  ModelGameSettings? modelGameSettings;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  start() {
    if (modelGameSettings!.dateTime == null || _timer != null) return;

    counter = modelGameSettings!.dateTime!
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    modelGameSettings =
        Provider.of<ProviderGameSettings>(context).modelGameSetting;
    start();
    if (counter == -1) return const SizedBox.shrink();
    return Text(counter.toString());
  }
}
