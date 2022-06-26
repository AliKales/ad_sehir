import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase/realtime.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/models/model_player.dart';
import 'package:ad_sehir/provider/provider_end_page.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/provider/provider_room_page.dart';
import 'package:ad_sehir/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndPage extends StatefulWidget {
  const EndPage({Key? key, this.answers}) : super(key: key);
  final List<String>? answers;

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
    WidgetsBinding.instance.addPostFrameCallback((_) => uploadREsults());
  }

  void uploadREsults() {
    Realtime.listenToResults(context: context);

    if (widget.answers != null) {
      Realtime.uploadResults(
          context: context,
          answers: widget.answers ?? ["aa", "bb", "cc"],
          categories: Values().getModelGameSettings!.categories!);
    }
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
              child: ListView.builder(
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
                        Text(_ctg),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${Values().getModelPlayerMe!.username}: ${results[Values().getModelPlayerMe!.id]?[_ctg]?['answer'] ?? ""}"),
                                InkWell(
                                    onTap: () {
                                      Realtime.changeTick(
                                          context: context,
                                          userId:
                                              Values().getModelPlayerMe!.id ??
                                                  "",
                                          category: _ctg,
                                          value: !_tickFromMe);
                                    },
                                    child: widgetTicks(_tickFromMe, _ticks)),
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: players.length,
                          itemBuilder: (context, i) {
                            Map _ticks =
                                results[players[i].id]?[_ctg]?['ticks'] ?? {};

                            bool _tickFromMe = results[players[i].id]?[_ctg]
                                        ?['ticks']?[
                                    "${Values().getModelPlayerMe!.id}|${Values().getModelPlayerMe!.username}"] ??
                                true;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${players[i].username}: ${results[players[i].id]?[_ctg]?['answer'] ?? ""}"),
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
            ),
          ),
        ),
      ),
    );
  }

  Wrap widgetTicks(bool _tickFromMe, Map<dynamic, dynamic> _tick) {
    return Wrap(
      children: List.generate(
        players.length + 1,
        (index) {
          bool _tickToSend = index == players.length
              ? _tickFromMe
              : (_tick["${players[index].id}|${players[index].username}"] ??
                  true);
          return getTick(
            index,
            _tickToSend,
          );
        },
      ),
    );
  }

  Widget getTick(int index, bool isTick) {
    Widget _icon = Icon(isTick ? Icons.check : Icons.cancel);

    if (index == players.length) {
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
