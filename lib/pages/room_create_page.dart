import 'dart:math';

import 'package:ad_sehir/UIs/custom_text_field.dart';
import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase/realtime.dart';
import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
import 'package:ad_sehir/simpleUIs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomCreatePage extends StatefulWidget {
  const RoomCreatePage({Key? key}) : super(key: key);

  @override
  State<RoomCreatePage> createState() => _RoomCreatePageState();
}

class _RoomCreatePageState extends State<RoomCreatePage> {
  TextEditingController tECMinute = TextEditingController();

  TextEditingController tECCategory = TextEditingController();

  late ModelGameSettings modelGameSettings;

  String letters = "a b c/ç d e f g h ı/i j k l m n o/ö p r s/ş t u/ü v y z";

  String whichLetter = "";

  final _random = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomLetter();
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    modelGameSettings =
        Provider.of<ProviderGameSettings>(context).modelGameSetting;
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text("Oda Ayarları"),
        backgroundColor: color1,
      ),
      body: body(context),
    );
  }

  body(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Kategoriler:",
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            ReorderableListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  key: ValueKey(index),
                  onLongPress: () => removeItem(context, index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "${index.toInt() + 1} - " +
                            modelGameSettings.categories![index],
                        style: Theme.of(context).textTheme.headline6),
                  ),
                );
              },
              itemCount: modelGameSettings.categories?.length ?? 0,
              onReorder: (int oldIndex, int newIndex) {},
            ),
            CustomTextField(hintText: "Kategori", tEC: tECCategory),
            const SizedBox(height: 20),
            SimpleUIs.elevatedButton(
                context: context,
                onPress: () => addCategory(context),
                text: "Ekle"),
            const Divider(),
            const SizedBox(height: 50),
            Text("Random Harf: $whichLetter"),
            SimpleUIs.elevatedButton(
                context: context,
                onPress: () => randomLetter(),
                text: "Yeni Harf"),
            const SizedBox(height: 50),
            SimpleUIs.elevatedButton(
                context: context,
                onPress: () => createRoom(context),
                text: "Oluştur")
          ],
        ),
      ),
    );
  }

  void randomLetter() {
    List<String> listLetters = letters.split(" ");
    String element = listLetters[_random.nextInt(listLetters.length)];
    setState(() {
      whichLetter = element;
    });
  }

  void addCategory(context) {
    modelGameSettings.categories ??= [];
    modelGameSettings.categories!.add(tECCategory.text.trim());
    tECCategory.clear();
    Provider.of<ProviderGameSettings>(context, listen: false)
        .update(modelGameSettings);
  }

  void removeItem(context, int index) {
    modelGameSettings.categories!.removeAt(index);
    Provider.of<ProviderGameSettings>(context, listen: false)
        .update(modelGameSettings);
  }

  Future createRoom(context) async {
    if ((modelGameSettings.categories?.isEmpty ?? true)) {
      Funcs().showSnackBar(context, "Kategori ekle.");
      return;
    }

    modelGameSettings.letter = whichLetter;

    String path = await Realtime.createRoom(
        context: context, modelGameSettings: modelGameSettings);

    Navigator.pop(context, path);
  }
}
