import 'package:ad_sehir/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key, this.hintText, this.tEC, this.isOnlyNumbers = false})
      : super(key: key);

  final String? hintText;
  final TextEditingController? tEC;
  final bool isOnlyNumbers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: tEC,
        style: const TextStyle(color: color4),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: color4),
          disabledBorder: customOutlineInputBorder(),
          border: customOutlineInputBorder(),
          enabledBorder: customOutlineInputBorder(),
          focusedBorder: customOutlineInputBorder(),
        ),
        keyboardType: (isOnlyNumbers) ? TextInputType.number : null,
        inputFormatters: isOnlyNumbers
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : null,
      ),
    );
  }

  OutlineInputBorder customOutlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: color4, width: 2),
    );
  }
}
