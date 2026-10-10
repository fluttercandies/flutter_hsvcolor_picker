import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('slider tap selects the position without dragging',
      (tester) async {
    final values = <double>[];
    await tester.pumpWidget(MaterialApp(
        home: Center(
            child: SizedBox(
                width: 200,
                child: SliderPicker(value: 0, onChanged: values.add)))));
    final rect = tester.getRect(find.byType(SliderPicker));
    await tester.tapAt(Offset(rect.left + 150, rect.center.dy));
    expect(values, isNotEmpty);
    expect(values.last, closeTo(.75, .001));
  });
  testWidgets('wheel tap uses the painted wheel center', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(MaterialApp(
        home: Center(
            child: WheelPicker(
                color: const HSVColor.fromAHSV(1, 180, 1, 1),
                onChanged: values.add))));
    final paint = find.descendant(
        of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    await tester.tapAt(Offset(rect.right - 8, rect.center.dy));
    expect(values, isNotEmpty);
    expect(values.last.hue, closeTo(0, .001));
  });
}
