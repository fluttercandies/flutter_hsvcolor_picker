import 'dart:math' as math;

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

  Widget wheel(
    List<HSVColor> values, {
    required bool showPalette,
    double hue = 180,
    double saturation = 1,
    double value = 1,
  }) =>
      MaterialApp(
        home: Center(
          child: WheelPicker(
            color: HSVColor.fromAHSV(1, hue, saturation, value),
            showPalette: showPalette,
            onChanged: values.add,
          ),
        ),
      );

  // Mirrors _WheelPainter: ring painted within radio ± 8, square half-side (radio - 8) / sqrt2, thumbs reach 12 + 6 / 2 = 15
  void expectUnpainted(Rect rect, Offset vector) {
    expect(rect.size, const Size(240, 228));
    final radio = math.min(rect.width, rect.height) / 2 - 8;
    final innerEdge = radio - 8;
    final squareRadio = (radio - 8) / 1.414213562373095;
    final wheelThumb = Offset.fromDirection(math.pi, radio); // hue 180
    final paletteThumb = Offset(squareRadio, -squareRadio); // s = 1, v = 1
    expect(vector.dx.abs() > squareRadio + 10 || vector.dy.abs() > squareRadio + 10, isTrue, reason: 'outside square');
    expect(vector.distance, lessThan(innerEdge - 10), reason: 'inside inner ring edge');
    expect((vector - wheelThumb).distance, greaterThan(15 + 10), reason: 'away from wheel thumb');
    expect((vector - paletteThumb).distance, greaterThan(15 + 10), reason: 'away from palette thumb');
  }

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

    testWidgets('wheel inner-gap tap does not change color (showPalette: $showPalette)', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      final rect = tester.getRect(paint);
      const vector = Offset(84, 0);
      expectUnpainted(rect, vector);
      await tester.tapAt(rect.center + vector);
      await tester.pump();
      expect(values, isEmpty, reason: 'tap at ${rect.center + vector} (center + $vector)');
    });

    testWidgets('wheel inner-gap drag start does not change color (showPalette: $showPalette)', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      final rect = tester.getRect(paint);
      const vector = Offset(0, 84);
      expectUnpainted(rect, vector);
      final gesture = await tester.startGesture(rect.center + vector);
      await gesture.moveTo(rect.center + const Offset(60, 60));
      await tester.pump();
      await gesture.moveTo(rect.center + const Offset(84, 0));
      await tester.pump();
      await gesture.up();
      expect(values, isEmpty, reason: 'drag start at ${rect.center + vector} (center + $vector)');
    });

    testWidgets('wheel touch over the palette thumb edge on the ring (showPalette: $showPalette)', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette, hue: 0));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      final rect = tester.getRect(paint);
      const squareRadio = (106 - 8) / 1.414213562373095;
      // 8.5 from the palette thumb (s = 1, v = 1) and 106.5 from the center, on the ring
      await tester.tapAt(rect.center + const Offset(squareRadio + 6, -squareRadio - 6));
      expect(values, hasLength(1));
      // The painted palette thumb covers the ring here; without the palette, the ring is on top
      expect(values.single, showPalette ? const HSVColor.fromAHSV(1, 0, 1, 1) : const HSVColor.fromAHSV(1, 315, 1, 1));
    });

    testWidgets('wheel thumb inside the palette square area (showPalette: $showPalette)', (tester) async {
      final values = <HSVColor>[];
      await tester.pumpWidget(wheel(values, showPalette: showPalette, hue: 45, saturation: .5, value: .5));
      final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
      final rect = tester.getRect(paint);
      // 93 from the center at 45 degrees: inside the square (69.3 per axis) and 13 from the wheel thumb
      await tester.tapAt(rect.center + Offset.fromDirection(math.pi / 4, 93));
      expect(values, hasLength(1));
      // The painted palette covers the wheel thumb here; without the palette, the wheel thumb is on top
      if (showPalette) {
        expect(values.single.hue, 45);
        expect(values.single.saturation, closeTo(.5 + 65.76 * .5 / 69.3, .001));
      } else {
        expect(values.single.hue, closeTo(45, .001));
        expect(values.single.saturation, .5);
      }
    });
  }

  testWidgets('wheel drag from the palette thumb edge moves the palette', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(wheel(values, showPalette: true, hue: 0));
    final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    const squareRadio = (106 - 8) / 1.414213562373095;
    final gesture = await tester.startGesture(rect.center + const Offset(squareRadio + 6, -squareRadio - 6));
    await gesture.moveTo(rect.center + const Offset(30, 0));
    await tester.pump();
    await gesture.moveTo(rect.center);
    await gesture.up();
    expect(values, isNotEmpty);
    expect(values.map((color) => color.hue), everyElement(0));
    expect(values.last, const HSVColor.fromAHSV(1, 0, .5, .5));
  });

  testWidgets('wheel palette thumb edge over the inner gap selects the palette', (tester) async {
    final values = <HSVColor>[];
    await tester.pumpWidget(wheel(values, showPalette: true, hue: 0, saturation: 0, value: .5));
    final paint = find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint));
    final rect = tester.getRect(paint);
    const squareRadio = (106 - 8) / 1.414213562373095;
    // 8 left of the palette thumb (s = 0, v = 0.5), in the inner gap
    await tester.tapAt(rect.center + const Offset(-squareRadio - 8, 0));
    expect(values, [const HSVColor.fromAHSV(1, 0, 0, .5)]);
  });
}
