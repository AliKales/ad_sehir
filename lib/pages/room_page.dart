import 'package:ad_sehir/UIs/custom_text_field.dart';
import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase/realtime.dart';
import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/models/model_player.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/provider/provider_room_page.dart';
import 'package:ad_sehir/simpleUIs.dart';
import 'package:ad_sehir/values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<ModelPlayer> players = [];
  TextEditingController tECUsername = TextEditingController();
  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => start());
  }

  start() {
    Realtime.startListeners(context: context, roomId: widget.roomId);
    Realtime().listenToGameSettings(context, widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    players = Provider.of<ProviderRoomPage>(context).players;
    if (players.isNotEmpty && players.first.id == Values.modelPlayerMe?.id) {
      Values.isLeader = true;
    }
    ModelGameSettings gameSettings =
        Provider.of<ProviderGameSettings>(context).modelGameSetting;
    if (gameSettings.gameStatus == GameStatus.game &&
        Values().getModelPlayerMe != null &&
        !isDone) {
      isDone = true;
      Realtime().stopListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          "/game?r=${widget.roomId}",
        );
      });
    }
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: color1,
        title: const Text("Oyun"),
      ),
      body: body(context),
    );
  }

  body(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.headline6!.copyWith(),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Oyuncular",
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                widgetContainerPlayers(context),
                if (Funcs().hasJoined(players))
                  WidgetUsernameJoin(
                      tECUsername: tECUsername, roomId: widget.roomId),
                const SizedBox(height: 50),
                const Divider(),
                if (!Funcs().hasJoined(players)) widgetGameSettings(context),
                const SizedBox(height: 50),
                if (players.isNotEmpty &&
                    players.first.id == Values.modelPlayerMe?.id)
                  SimpleUIs.elevatedButton(
                      context: context,
                      onPress: () {
                        Realtime.startGame(
                            context: context, roomId: widget.roomId);
                      },
                      text: "Başlat"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container widgetGameSettings(context) {
    return Container(
      decoration: const BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      width: MediaQuery.of(context).size.width / 3,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text("Oyun Ayarları"),
          const SizedBox(height: 10),
          Text("Dakika: ${Values.modelGameSettings?.minute ?? 0}"),
          const SizedBox(height: 10),
          Text(
              "Kategori sayısı: ${Values.modelGameSettings?.categories?.length ?? 0}"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Container widgetContainerPlayers(context) {
    return Container(
      decoration: const BoxDecoration(
        color: color3,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      width: MediaQuery.of(context).size.width / 3,
      child: ListView.builder(
        itemCount: players.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          ModelPlayer modelPlayer = players[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text("${index.toInt() + 1}- ${modelPlayer.username}"),
            ),
          );
        },
      ),
    );
  }
}

class WidgetUsernameJoin extends StatelessWidget {
  const WidgetUsernameJoin({
    Key? key,
    required this.tECUsername,
    required this.roomId,
  }) : super(key: key);

  final TextEditingController tECUsername;
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        CustomTextField(hintText: "Username", tEC: tECUsername),
        const SizedBox(height: 20),
        SimpleUIs.elevatedButton(
            context: context,
            onPress: () {
              if (tECUsername.text.trim() == "") {
                Funcs().showSnackBar(context, "Username boş kalamaz!");
                return;
              }
              Realtime.joinToRoom(
                  context: context,
                  username: tECUsername.text.trim(),
                  roomId: roomId);
            },
            text: "Katıl"),
      ],
    );
  }
}
