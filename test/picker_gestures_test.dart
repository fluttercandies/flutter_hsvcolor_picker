import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
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
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(width: 200, child: SliderPicker(value: 0, onChanged: values.add)),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(SliderPicker));
    final gesture = await tester.startGesture(Offset(rect.left + 150, rect.center.dy));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(values, isEmpty);
  });

  testWidgets('cancelled wheel press does not select a color', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: WheelPicker(color: const HSVColor.fromAHSV(1, 180, 1, 1), onChanged: values.add),
        ),
      ),
    );
    final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    final gesture = await tester.startGesture(Offset(rect.right - 8, rect.center.dy));
    await gesture.cancel();
    await tester.pumpAndSettle();
    expect(values, isEmpty);
  });

  testWidgets('slider tap selects the position without dragging', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(width: 200, child: SliderPicker(value: 0, onChanged: values.add)),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(SliderPicker));
    await tester.tapAt(Offset(rect.left + 150, rect.center.dy));
    expect(values, isNotEmpty);
    expect(values.last, closeTo(.75, .001));
  });
  testWidgets('wheel tap uses the painted wheel center', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: WheelPicker(color: const HSVColor.fromAHSV(1, 180, 1, 1), onChanged: values.add),
        ),
      ),
    );
    final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    await tester.tapAt(Offset(rect.right - 8, rect.center.dy));
    expect(values, isNotEmpty);
    expect(values.last.hue, closeTo(0, .001));
  });

  testWidgets('slider drag still selects the final position', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(width: 200, child: SliderPicker(value: 0, onChanged: values.add)),
        ),
      ),
    );
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
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: WheelPicker(color: const HSVColor.fromAHSV(1, 180, 1, 1), onChanged: values.add),
        ),
      ),
    );
    final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    final gesture = await tester.startGesture(Offset(rect.right - 8, rect.center.dy));
    await gesture.moveTo(Offset(rect.center.dx + 60, rect.center.dy + 60));
    await tester.pump();
    await gesture.moveTo(Offset(rect.center.dx, rect.bottom - 8));
    await gesture.up();
    expect(values, isNotEmpty);
    expect(values.last.hue, closeTo(90, .001));
  });

  Widget wheel(List<HSVColor> values, {required bool showPalette, double hue = 180}) => MaterialApp(
    home: Center(
      child: WheelPicker(color: HSVColor.fromAHSV(1, hue, 1, 1), showPalette: showPalette, onChanged: values.add),
    ),
  );

  for (final showPalette in [true, false]) {
    testWidgets('wheel central palette tap respects showPalette: $showPalette', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      await tester.tapAt(tester.getCenter(paint));

      expect(values, hasLength(showPalette ? 1 : 0));
      if (showPalette) {
        expect(values.single, const HSVColor.fromAHSV(1, 180, .5, .5));
      }
    });

    testWidgets('wheel transparent corner taps are ignored (showPalette: $showPalette)', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      final rect = tester.getRect(paint);
      for (final corner in [
        rect.topLeft + const Offset(4, 4),
        rect.topRight + const Offset(-4, 4),
        rect.bottomLeft + const Offset(4, -4),
        rect.bottomRight + const Offset(-4, -4),
      ]) {
        await tester.tapAt(corner);
        await tester.pump();
      }
      expect(values, isEmpty);
    });

    testWidgets('wheel drag from a transparent corner is ignored (showPalette: $showPalette)', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      final rect = tester.getRect(paint);
      final gesture = await tester.startGesture(rect.topLeft + const Offset(4, 4));
      await gesture.moveTo(rect.center + const Offset(-75, -75));
      await tester.pump();
      await gesture.moveTo(Offset(rect.left + 8, rect.center.dy));
      await tester.pump();
      await gesture.up();
      expect(values, isEmpty);
    });

    testWidgets('wheel thumb outside the ring still starts a wheel drag (showPalette: $showPalette)', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette, hue: 45));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      final rect = tester.getRect(paint);
      // 118 from the center: outside the ring (114) but on the thumb (106 + 15)
      final gesture = await tester.startGesture(rect.center + Offset.fromDirection(math.pi / 4, 118));
      await gesture.moveTo(rect.center);
      await tester.pump();
      await gesture.moveTo(Offset(rect.center.dx, rect.top + 8));
      await gesture.up();
      expect(values, hasLength(3));
      expect(values.first.hue, closeTo(45, .001));
      expect(values[1].hue, closeTo(0, .001));
      expect(values.last.hue, closeTo(270, .001));
    });
  }
}
