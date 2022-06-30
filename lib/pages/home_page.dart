import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/pages/room_create_page.dart';
import 'package:ad_sehir/simpleUIs.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        title: const Text(
          "İsim Şehir",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: color1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height) /
                    2.5,
              ),
              SimpleUIs.elevatedButton(
                context: context,
                onPress: () async {
                  var path = await Funcs()
                      .navigatorPush(context, const RoomCreatePage());

                  if (path != null) {
                    Navigator.pushReplacementNamed(context, "/room?r=$path");
                  }
                },
                text: "Oda Kur",
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height) /
                    2.5,
              ),
              Column(
                children: [
                  const Text("Diğer oyuna da göz at"),
                  const SizedBox(
                    height: 10,
                  ),
                  SimpleUIs.elevatedButton(
                      context: context,
                      onPress: () {
                        js.context.callMethod(
                            'open', ['https://quiz-app-89650.web.app']);
                      },
                      text: "Oyuna Git"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
