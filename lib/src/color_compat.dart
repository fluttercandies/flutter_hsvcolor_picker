import 'package:flutter/material.dart';

int colorToArgb32(Color color) {
  final dynamic compatibleColor = color;
  return compatibleColor.value as int;
}
