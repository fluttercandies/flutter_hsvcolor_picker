import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget palette(List<Offset> values) => MaterialApp(
        home: Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: PalettePicker(
              position: Offset.zero,
              onChanged: values.add,
              leftRightColors: const [Colors.black, Colors.white],
              topBottomColors: const [Colors.transparent, Colors.black],
            ),
          ),
        ),
      );

  testWidgets('cancelled palette press does not select a color', (tester) async {
    final values = <Offset>[];
    await tester.pumpWidget(palette(values));
    final rect = tester.getRect(find.byType(PalettePicker));
    final gesture = await tester.startGesture(Offset(rect.left + 150, rect.top + 50));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(values, isEmpty);
  });

  testWidgets('palette tap selects both values without dragging', (tester) async {
    final values = <Offset>[];
    await tester.pumpWidget(palette(values));
    final rect = tester.getRect(find.byType(PalettePicker));
    await tester.tapAt(Offset(rect.left + 150, rect.top + 50));
    expect(values, isNotEmpty);
    expect(values.last, const Offset(.75, .25));
  });

  testWidgets('palette drag still selects the final position', (tester) async {
    final values = <Offset>[];
    await tester.pumpWidget(palette(values));
    final rect = tester.getRect(find.byType(PalettePicker));
    final gesture = await tester.startGesture(Offset(rect.left + 50, rect.top + 50));
    await gesture.moveTo(Offset(rect.left + 100, rect.top + 100));
    await tester.pump();
    await gesture.moveTo(Offset(rect.left + 150, rect.top + 150));
    await gesture.up();
    expect(values, isNotEmpty);
    expect(values.last, const Offset(.75, .75));
  });

  testWidgets('cancelled slider press does not select a color', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(MaterialApp(
      home: Center(
        child: SizedBox(
          width: 200,
          child: SliderPicker(value: 0, onChanged: values.add),
        ),
      ),
    ));
    final rect = tester.getRect(find.byType(SliderPicker));
    final gesture = await tester.startGesture(Offset(rect.left + 150, rect.center.dy));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(values, isEmpty);
  });

  testWidgets('cancelled wheel press does not select a color', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(MaterialApp(
      home: Center(
        child: WheelPicker(
          color: const HSVColor.fromAHSV(1, 180, 1, 1),
          onChanged: values.add,
        ),
      ),
    ));
    final paint = find.descendant(
      of: find.byType(WheelPicker),
      matching: find.byType(CustomPaint),
    );
    final rect = tester.getRect(paint);
    final gesture = await tester.startGesture(Offset(rect.right - 8, rect.center.dy));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(values, isEmpty);
  });

  testWidgets('slider tap selects the position without dragging', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(
        MaterialApp(home: Center(child: SizedBox(width: 200, child: SliderPicker(value: 0, onChanged: values.add)))));
    final rect = tester.getRect(find.byType(SliderPicker));
    await tester.tapAt(Offset(rect.left + 150, rect.center.dy));
    expect(values, isNotEmpty);
    expect(values.last, closeTo(.75, .001));
  });
  testWidgets('wheel tap uses the painted wheel center', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(MaterialApp(
        home: Center(child: WheelPicker(color: const HSVColor.fromAHSV(1, 180, 1, 1), onChanged: values.add))));
    final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    await tester.tapAt(Offset(rect.right - 8, rect.center.dy));
    expect(values, isNotEmpty);
    expect(values.last.hue, closeTo(0, .001));
  });

  testWidgets('slider drag still selects the final position', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(MaterialApp(
      home: Center(
        child: SizedBox(
          width: 200,
          child: SliderPicker(value: 0, onChanged: values.add),
        ),
      ),
    ));
    final rect = tester.getRect(find.byType(SliderPicker));
    final gesture = await tester.startGesture(Offset(rect.left + 50, rect.center.dy));
    await gesture.moveTo(Offset(rect.left + 100, rect.center.dy));
    await tester.pump();
    await gesture.moveTo(Offset(rect.left + 150, rect.center.dy));
    await gesture.up();
    expect(values, isNotEmpty);
    expect(values.last, closeTo(.75, .001));
  });

  testWidgets('wheel drag still follows the painted hue', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(MaterialApp(
      home: Center(
        child: WheelPicker(
          color: const HSVColor.fromAHSV(1, 180, 1, 1),
          onChanged: values.add,
        ),
      ),
    ));
    final paint = find.descendant(
      of: find.byType(WheelPicker),
      matching: find.byType(CustomPaint),
    );
    final rect = tester.getRect(paint);
    final gesture = await tester.startGesture(Offset(rect.right - 8, rect.center.dy));
    await gesture.moveTo(Offset(rect.center.dx + 60, rect.center.dy + 60));
    await tester.pump();
    await gesture.moveTo(Offset(rect.center.dx, rect.bottom - 8));
    await gesture.up();
    expect(values, isNotEmpty);
    expect(values.last.hue, closeTo(90, .001));
  });
}
