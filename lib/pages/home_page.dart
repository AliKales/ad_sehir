import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/funcs.dart';
import 'package:ad_sehir/pages/room_create_page.dart';
import 'package:ad_sehir/simpleUIs.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: SimpleUIs.elevatedButton(
          context: context,
          onPress: () async {
            var modelGameSettings =
                await Funcs().navigatorPush(context, RoomCreatePage());
            Navigator.pushNamed(context, "/r=");
          },
          text: "Oda Kur",
        ),
      ),
    );
  }
}
