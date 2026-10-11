import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HSV uses degrees for hue and percentages for saturation/value', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: HSVPicker(
          color: const HSVColor.fromAHSV(1, 240, 0.4, 0.6),
          onChanged: (_) {},
        ),
      ),
    ));
    expect(find.text('240º'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('V'), findsOneWidget);
    expect(find.text('L'), findsNothing);
  });
}
