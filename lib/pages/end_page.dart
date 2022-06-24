import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/firebase/realtime.dart';
import 'package:ad_sehir/models/model_game_settings.dart';
import 'package:ad_sehir/provider/provider_game_settings.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadREsults();
  }

  void uploadREsults() {
    if (widget.answers == null) {
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
      floatingActionButton:
          FloatingActionButton(onPressed: () => uploadREsults()),
      backgroundColor: color1,
      body: body(),
    );
  }

  body() {
    modelGameSettings =
        Provider.of<ProviderGameSettings>(context).modelGameSetting;
    print(modelGameSettings.categories);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: color2,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            width: MediaQuery.of(context).size.width / 1.5,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6!.copyWith(),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: modelGameSettings.categories?.length ?? 10,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(modelGameSettings.categories?[index] ?? ""),
                        const Divider(),
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
}
