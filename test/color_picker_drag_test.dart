import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

// One value a picker shows: a slider position, a palette axis or a wheel component
class Shown {
  Shown(this.name, this.value, this.min, this.max);

  final String name;
  final double value;
  final double min;
  final double max;
}

class Expected {
  const Expected(this.value, {this.isExact = true});

  final double value;
  final bool isExact;
}

const double rangeOutside = 40;

// Mirrors the example: the parent stores every reported color and passes it back
Future<void> pumpPicker(WidgetTester tester, Picker picker) async {
  await tester.binding.setSurfaceSize(const Size(500, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final colorNotifier = ValueNotifier<Color>(Colors.green);
  addTearDown(colorNotifier.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ValueListenableBuilder<Color>(
              valueListenable: colorNotifier,
              builder: (_, color, __) => ColorPicker(
                color: color,
                initialPicker: picker,
                pickerOrientation: PickerOrientation.portrait,
                onChanged: (value) => colorNotifier.value = value,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Finder sliders() => find.byType(SliderPicker);

List<Shown> shown(WidgetTester tester) {
  final values = <Shown>[];
  final sliderWidgets = tester.widgetList<SliderPicker>(sliders()).toList();
  for (var i = 0; i < sliderWidgets.length; i++) {
    final slider = sliderWidgets[i];
    values.add(Shown('slider $i', slider.value, slider.min, slider.max));
  }
  for (final palette in tester.widgetList<PalettePicker>(find.byType(PalettePicker))) {
    values
      ..add(Shown(
        'palette x',
        palette.position.dx,
        math.min(palette.leftPosition, palette.rightPosition),
        math.max(palette.leftPosition, palette.rightPosition),
      ))
      ..add(Shown(
        'palette y',
        palette.position.dy,
        math.min(palette.topPosition, palette.bottomPosition),
        math.max(palette.topPosition, palette.bottomPosition),
      ));
  }
  for (final wheel in tester.widgetList<WheelPicker>(find.byType(WheelPicker))) {
    values
      ..add(Shown('wheel hue', wheel.color.hue, 0, 360))
      ..add(Shown('wheel saturation', wheel.color.saturation, 0, 1))
      ..add(Shown('wheel value', wheel.color.value, 0, 1));
  }

  return values;
}

int indexOf(WidgetTester tester, String name) => shown(tester).indexWhere((value) => value.name == name);

// Drags in steps and checks after every step that only the dragged control changes
Future<void> checkDrag(
  WidgetTester tester,
  String label,
  Offset from,
  Offset to,
  Map<int, Expected> changed,
) async {
  final before = shown(tester);

  void expectOthersUnchanged(String step) {
    final current = shown(tester);
    expect(current, hasLength(before.length), reason: '$label, $step');
    for (var i = 0; i < before.length; i++) {
      if (changed.containsKey(i)) continue;
      expect(
        current[i].value,
        closeTo(before[i].value, 1e-9),
        reason: '$label, $step: ${before[i].name} moved from ${before[i].value} to ${current[i].value}',
      );
    }
  }

  final gesture = await tester.startGesture(from);
  for (var step = 1; step <= 4; step++) {
    await gesture.moveTo(Offset.lerp(from, to, step / 4)!);
    await tester.pump();
    expectOthersUnchanged('step $step');
  }
  await gesture.up();
  await tester.pump();
  expectOthersUnchanged('release');

  final after = shown(tester);
  changed.forEach((index, expected) {
    final range = after[index].max - after[index].min;
    expect(
      after[index].value,
      closeTo(expected.value, expected.isExact ? 1e-9 : range * .01),
      reason: '$label: ${after[index].name}',
    );
  });
}

Future<void> dragSlider(WidgetTester tester, int index, String end) async {
  final rect = tester.getRect(sliders().at(index));
  final slider = tester.widgetList<SliderPicker>(sliders()).elementAt(index);
  final Offset to;
  final Expected expected;
  if (end == 'left') {
    to = Offset(rect.left - rangeOutside, rect.center.dy);
    expected = Expected(slider.min);
  } else if (end == 'right') {
    to = Offset(rect.right + rangeOutside, rect.center.dy);
    expected = Expected(slider.max);
  } else {
    to = Offset(rect.left + rect.width / 3, rect.center.dy);
    expected = Expected(slider.min + (slider.max - slider.min) / 3, isExact: false);
  }
  await checkDrag(tester, 'slider $index to $end', rect.center, to, <int, Expected>{index: expected});
}

Future<void> dragPalette(WidgetTester tester, String horizontal, String vertical) async {
  final rect = tester.getRect(find.byType(PalettePicker));
  final palette = tester.widget<PalettePicker>(find.byType(PalettePicker));
  double target(String side, double start, double end, double startPosition, double endPosition, List<Expected> out) {
    if (side == 'start') {
      out.add(Expected(startPosition));
      return start - rangeOutside;
    }
    if (side == 'end') {
      out.add(Expected(endPosition));
      return end + rangeOutside;
    }
    out.add(Expected((startPosition + endPosition) / 2, isExact: false));
    return (start + end) / 2;
  }

  final expected = <Expected>[];
  final x = target(horizontal, rect.left, rect.right, palette.leftPosition, palette.rightPosition, expected);
  final y = target(vertical, rect.top, rect.bottom, palette.topPosition, palette.bottomPosition, expected);
  await checkDrag(
    tester,
    'palette to $horizontal/$vertical',
    rect.center,
    Offset(x, y),
    <int, Expected>{indexOf(tester, 'palette x'): expected[0], indexOf(tester, 'palette y'): expected[1]},
  );
}

const sides = <String>['start', 'middle', 'end'];
const sliderEnds = <String>['left', 'third', 'right'];

void main() {
  for (final picker in <Picker>[Picker.paletteHue, Picker.paletteSaturation, Picker.paletteValue]) {
    testWidgets('${picker.name}: every palette edge and corner keeps the slider, and the slider keeps the palette',
        (tester) async {
      await pumpPicker(tester, picker);
      for (final horizontal in sides) {
        for (final vertical in sides) {
          await dragPalette(tester, horizontal, vertical);
          for (final end in sliderEnds) {
            await dragSlider(tester, 0, end);
          }
        }
      }
      for (final end in sliderEnds) {
        await dragSlider(tester, 1, end);
      }
    });
  }

  for (final picker in <Picker>[Picker.hsv, Picker.rgb]) {
    testWidgets('${picker.name}: every slider combination of left and right keeps the other sliders', (tester) async {
      await pumpPicker(tester, picker);
      for (final first in sliderEnds) {
        await dragSlider(tester, 0, first);
        for (final second in sliderEnds) {
          await dragSlider(tester, 1, second);
          for (final third in sliderEnds) {
            await dragSlider(tester, 2, third);
          }
        }
      }
      for (final end in sliderEnds) {
        await dragSlider(tester, 3, end);
      }
    });
  }

  testWidgets('wheel: every square edge and corner keeps the hue, and the ring keeps the square', (tester) async {
    await pumpPicker(tester, Picker.wheel);
    final rect = tester.getRect(find.descendant(of: find.byType(WheelPicker), matching: find.byType(CustomPaint)));
    final center = rect.center;
    // Mirrors _WheelPainter: ring radius min(size) / 2 - 8, square half-side (radius - 8) / sqrt2
    final radius = math.min(rect.width, rect.height) / 2 - 8;
    final squareRadius = (radius - 8) / math.sqrt2;
    final hue = indexOf(tester, 'wheel hue');
    final saturation = indexOf(tester, 'wheel saturation');
    final value = indexOf(tester, 'wheel value');

    final squareSides = <String, double>{'start': -squareRadius - 12, 'middle': 0, 'end': squareRadius + 12};
    for (final horizontal in sides) {
      for (final vertical in sides) {
        await checkDrag(
          tester,
          'square to $horizontal/$vertical',
          center,
          center + Offset(squareSides[horizontal]!, squareSides[vertical]!),
          <int, Expected>{
            saturation: Expected(<String, double>{'start': 0, 'middle': .5, 'end': 1}[horizontal]!),
            value: Expected(<String, double>{'start': 1, 'middle': .5, 'end': 0}[vertical]!),
          },
        );
        for (final degrees in <double>[0, 90, 180, 270, 359]) {
          final radians = degrees * math.pi / 180;
          await checkDrag(
            tester,
            'ring to $degrees° after square $horizontal/$vertical',
            center + Offset(radius, 0),
            center + Offset(math.cos(radians) * radius, math.sin(radians) * radius),
            <int, Expected>{hue: Expected(degrees, isExact: false)},
          );
        }
      }
    }
    for (final end in sliderEnds) {
      await dragSlider(tester, 0, end);
    }
  });
}
