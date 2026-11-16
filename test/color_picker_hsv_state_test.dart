import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

const hsvPickers = <Picker>[Picker.hsv, Picker.wheel, Picker.paletteHue, Picker.paletteSaturation, Picker.paletteValue];

HSVColor shownColor(WidgetTester tester, Picker picker) {
  switch (picker) {
    case Picker.hsv:
      return tester.widget<HSVPicker>(find.byType(HSVPicker)).color;
    case Picker.wheel:
      return tester.widget<WheelPicker>(find.byType(WheelPicker)).color;
    case Picker.paletteHue:
      return tester.widget<PaletteHuePicker>(find.byType(PaletteHuePicker)).color;
    case Picker.paletteSaturation:
      return tester.widget<PaletteSaturationPicker>(find.byType(PaletteSaturationPicker)).color;
    case Picker.paletteValue:
      return tester.widget<PaletteValuePicker>(find.byType(PaletteValuePicker)).color;
    default:
      throw ArgumentError.value(picker);
  }
}

void changeColor(WidgetTester tester, Picker picker, HSVColor color) {
  switch (picker) {
    case Picker.hsv:
      return tester.widget<HSVPicker>(find.byType(HSVPicker)).onChanged(color);
    case Picker.wheel:
      return tester.widget<WheelPicker>(find.byType(WheelPicker)).onChanged(color);
    case Picker.paletteHue:
      return tester.widget<PaletteHuePicker>(find.byType(PaletteHuePicker)).onChanged(color);
    case Picker.paletteSaturation:
      return tester.widget<PaletteSaturationPicker>(find.byType(PaletteSaturationPicker)).onChanged(color);
    case Picker.paletteValue:
      return tester.widget<PaletteValuePicker>(find.byType(PaletteValuePicker)).onChanged(color);
    default:
      throw ArgumentError.value(picker);
  }
}

// Mirrors the example: the parent stores every reported color and passes it back
Future<ValueNotifier<Color>> pumpControlledPicker(WidgetTester tester, Picker picker) async {
  final colorNotifier = ValueNotifier<Color>(const Color.fromARGB(0x80, 0x33, 0x66, 0x99));
  addTearDown(colorNotifier.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
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
  );

  return colorNotifier;
}

void expectHsv(HSVColor actual, HSVColor expected) {
  expect(actual.hue, closeTo(expected.hue, 1e-9));
  expect(actual.saturation, closeTo(expected.saturation, 1e-9));
  expect(actual.value, closeTo(expected.value, 1e-9));
}

void main() {
  for (final picker in hsvPickers) {
    group(picker.name, () {
      testWidgets('keeps hue and saturation at zero brightness', (tester) async {
        await pumpControlledPicker(tester, picker);
        const black = HSVColor.fromAHSV(1, 200, .6, 0);

        changeColor(tester, picker, black);
        await tester.pump();

        expectHsv(shownColor(tester, picker), black);
      });

      testWidgets('keeps hue at zero saturation', (tester) async {
        await pumpControlledPicker(tester, picker);
        const gray = HSVColor.fromAHSV(1, 200, 0, .7);

        changeColor(tester, picker, gray);
        await tester.pump();

        expectHsv(shownColor(tester, picker), gray);
      });

      testWidgets('keeps the exact selection instead of rounding it to RGB', (tester) async {
        await pumpControlledPicker(tester, picker);
        const selection = HSVColor.fromAHSV(1, 200.4, .537, .712);

        changeColor(tester, picker, selection);
        await tester.pump();

        expectHsv(shownColor(tester, picker), selection);
      });
    });
  }

  testWidgets('alpha changes keep the selected hue of a gray', (tester) async {
    final colorNotifier = await pumpControlledPicker(tester, Picker.hsv);
    const gray = HSVColor.fromAHSV(1, 200, 0, .7);
    changeColor(tester, Picker.hsv, gray);
    await tester.pump();

    tester.widget<AlphaPicker>(find.byType(AlphaPicker)).onChanged(0x22);
    await tester.pump();

    expectHsv(shownColor(tester, Picker.hsv), gray);
    expect(colorNotifier.value, isSameColorAs(gray.toColor().withAlpha(0x22)));
  });

  testWidgets('HSV changes report the RGB color with the current alpha', (tester) async {
    final colorNotifier = await pumpControlledPicker(tester, Picker.wheel);
    const selection = HSVColor.fromAHSV(1, 200.4, .537, .712);

    changeColor(tester, Picker.wheel, selection);
    await tester.pump();

    expect(colorNotifier.value, isSameColorAs(selection.toColor().withAlpha(0x80)));
    expect(shownColor(tester, Picker.wheel).alpha, closeTo(0x80 / 0xff, 1e-9));
  });

  testWidgets('a new color from the parent replaces the HSV selection', (tester) async {
    final colorNotifier = await pumpControlledPicker(tester, Picker.hsv);
    changeColor(tester, Picker.hsv, const HSVColor.fromAHSV(1, 200, 0, .7));
    await tester.pump();

    colorNotifier.value = const Color.fromARGB(0xff, 0xff, 0, 0);
    await tester.pump();

    expectHsv(shownColor(tester, Picker.hsv), const HSVColor.fromAHSV(1, 0, 1, 1));
  });
}
