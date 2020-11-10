import 'package:flutter/material.dart';

const Color Green = Color.fromRGBO(17, 118, 78, 1.0);
const Color Yellow = Color.fromRGBO(190, 133, 48, 1.0);
const Color Grey = Color.fromRGBO(166, 175, 179, 1.0);
const Color LightGrey = Color.fromRGBO(229, 239, 236, 1.0);

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
