import 'package:flutter/material.dart';

// Keep the pickers' eight-bit channel behavior on older and newer Flutter SDKs.
// Color.toARGB32 is unavailable before Flutter 3.27.
extension ColorChannels on Color {
  int get _argb {
    // ignore: deprecated_member_use
    return value;
  }

  int get alpha8 => (_argb >> 24) & 0xff;
  int get red8 => (_argb >> 16) & 0xff;
  int get green8 => (_argb >> 8) & 0xff;
  int get blue8 => _argb & 0xff;
}
