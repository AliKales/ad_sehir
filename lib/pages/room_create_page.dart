import 'package:ad_sehir/colors.dart';
import 'package:ad_sehir/simpleUIs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomCreatePage extends StatelessWidget {
  const RoomCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
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
    return Padding(
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
              return Padding(
                key: ValueKey(index),
                padding: const EdgeInsets.all(8.0),
                child: Text(index.toString(),
                    style: Theme.of(context).textTheme.headline6),
              );
            },
            itemCount: 10,
            onReorder: (int oldIndex, int newIndex) {},
          ),
          const Divider(),
          SizedBox(
            width: 200,
            child: TextField(
              style: const TextStyle(color: color4),
              decoration: InputDecoration(
                hintText: "Dakika",
                hintStyle: const TextStyle(color: color4),
                disabledBorder: customOutlineInputBorder(),
                border: customOutlineInputBorder(),
                enabledBorder: customOutlineInputBorder(),
                focusedBorder: customOutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          const SizedBox(height: 50),
          SimpleUIs.elevatedButton(
              context: context, onPress: () {}, text: "Oluştur")
        ],
      ),
    );
  }

  OutlineInputBorder customOutlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: color4, width: 2),
    );
  }
}
