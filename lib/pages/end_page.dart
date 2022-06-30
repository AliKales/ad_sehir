import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase/realtime.dart';
import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/models/model_player.dart';
import 'package:ad_sehir/provider/provider_end_page.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/provider/provider_room_page.dart';
import 'package:ad_sehir/simpleUIs.dart';
import 'package:ad_sehir/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndPage extends StatefulWidget {
  const EndPage({Key? key, this.answers, required this.roomId})
      : super(key: key);
  final List<String>? answers;
  final String roomId;

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  ModelGameSettings modelGameSettings = ModelGameSettings();
  Map results = {};
  List<ModelPlayer> players = [];
  List resultsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    players = Provider.of<ProviderRoomPage>(context, listen: false).players;
    WidgetsBinding.instance.addPostFrameCallback((_) => listenToResults());
  }

  void listenToResults() {
    Realtime.listenToResults(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sonuçlar"),
        automaticallyImplyLeading: false,
        backgroundColor: color1,
      ),
      backgroundColor: color1,
      body: body(),
    );
  }

  body() {
    modelGameSettings =
        Provider.of<ProviderGameSettings>(context).modelGameSetting;

    results = Provider.of<ProviderEndPage>(context).results;

    // if (players.indexWhere(
    //         (element) => element.id == Values().getModelPlayerMe!.id) ==
    //     -1) {
    //   players.add(Values().getModelPlayerMe!);
    //   players.sort(
    //     (a, b) => a.username!.compareTo(b.username!),
    //   );
    // }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6!.copyWith(),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modelGameSettings.categories?.length ?? 5,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      String _ctg = modelGameSettings.categories?[index] ?? "";
                      Map _ticks = results[Values().getModelPlayerMe!.id]?[_ctg]
                              ?['ticks'] ??
                          {};

                      bool _tickFromMe = results[Values().getModelPlayerMe!.id]
                                  ?[_ctg]?['ticks']?[
                              "${Values().getModelPlayerMe!.id}|${Values().getModelPlayerMe!.username}"] ??
                          true;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(_ctg
                                .toString()
                                .replaceAll("aynisinemalar", "")),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: players.length,
                              itemBuilder: (context, i) {
                                Map _ticks = results[players[i].id]?[_ctg]
                                        ?['ticks'] ??
                                    {};

                                bool _tickFromMe = results[players[i].id]?[_ctg]
                                            ?['ticks']?[
                                        "${Values().getModelPlayerMe!.id}|${Values().getModelPlayerMe!.username}"] ??
                                    true;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getTextWithSpeaker(i, _ctg),
                                      InkWell(
                                        onTap: () {
                                          Realtime.changeTick(
                                              context: context,
                                              userId: players[i].id ?? "",
                                              category: _ctg,
                                              value: !_tickFromMe);
                                        },
                                        child: widgetTicks(_tickFromMe, _ticks),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  WidgetPoints(players: players, results: results),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTextWithSpeaker(int i, String _ctg) {
    if (!_ctg.contains("aynisinemalar")) {
      return Text(
          "${players[i].username}: ${results[players[i].id]?[_ctg]?['answer'] ?? ""}");
    }
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Funcs().speak(results[players[i].id]?[_ctg]?['answer'] ?? "");
            },
            icon: const Icon(Icons.volume_up)),
        Text(
            "${players[i].username}: ${results[players[i].id]?[_ctg]?['answer'] ?? ""}"),
      ],
    );
  }

  Wrap widgetTicks(bool _tickFromMe, Map<dynamic, dynamic> _tick) {
    int whereMe = players
        .indexWhere((element) => element.id == Values().getModelPlayerMe?.id);
    return Wrap(
      children: List.generate(
        players.length,
        (index) {
          bool _tickToSend = index == whereMe
              ? _tickFromMe
              : (_tick["${players[index].id}|${players[index].username}"] ??
                  true);
          return getTick(
            index,
            _tickToSend,
            index == whereMe,
          );
        },
      ),
    );
  }

  Widget getTick(int index, bool isTick, bool isMe) {
    Widget _icon = Icon(isTick ? Icons.check : Icons.cancel);

    if (isMe) {
      return Container(
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: color4)),
          child: _icon);
    } else {
      return _icon;
    }
  }
}

class WidgetPoints extends StatefulWidget {
  const WidgetPoints({Key? key, required this.players, required this.results})
      : super(key: key);
  final List<ModelPlayer> players;
  final Map results;

  @override
  State<WidgetPoints> createState() => _WidgetPointsState();
}

class _WidgetPointsState extends State<WidgetPoints> {
  bool isShown = false;
  List<Map> points = [];

  @override
  Widget build(BuildContext context) {
    if (isShown) {
      return Column(
        children: [
          const Text("Puanlar"),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: color2,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.players.length,
              itemBuilder: (context, index) {
                return Text(
                    "$index- ${points[index]['username']}: ${points[index]['point']}");
              },
            ),
          ),
        ],
      );
    } else {
      return SimpleUIs.elevatedButton(
          context: context,
          onPress: () {
            calculatePoints();
          },
          text: "Puanları Gör");
    }
  }

  void calculatePoints() {
    int point = 0;
    for (var player in widget.players) {
      point = 0;
      for (var category in Values().getModelGameSettings?.categories ?? []) {
        Map _ticks = widget.results[player.id][category]['ticks'];
        int howManyTicks = _ticks.values.where((element) => element).length;

        point += howManyTicks * 5;
      }
      points.add({'username': player.username, 'point': point});
    }

    points.sort(
      (a, b) => a['point'] < b['point'] ? 1 : 0,
    );

    setState(() {
      isShown = true;
    });
  }
}
