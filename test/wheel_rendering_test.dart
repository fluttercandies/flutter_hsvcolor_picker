import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the painted wheel east point matches its red hue selection',
      (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(MaterialApp(
        home: Center(
            child: RepaintBoundary(
      key: key,
      child: WheelPicker(
          color: const HSVColor.fromAHSV(1, 180, 1, 1), onChanged: (_) {}),
    ))));
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final paint = find.descendant(
        of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    final local =
        boundary.globalToLocal(Offset(rect.right - 16, rect.center.dy));
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage();
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final offset = (local.dy.floor() * image.width + local.dx.floor()) * 4;
        return List<int>.generate(
            4, (channel) => data!.getUint8(offset + channel));
      } finally {
        image.dispose();
      }
    });
    expect(bytes![0], closeTo(255, 1));
    expect(bytes[1], closeTo(0, 1));
    expect(bytes[2], closeTo(0, 1));
    expect(bytes[3], 255);
  });
}
