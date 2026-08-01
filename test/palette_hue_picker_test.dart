import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selects pink from the hue slider and palette', (tester) async {
    var selected = const HSVColor.fromAHSV(1, 0, 0.2, 0.2);

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => PaletteHuePicker(
            color: selected,
            onChanged: (color) => setState(() => selected = color),
          ),
        ),
      ),
    );

    final sliderFinder = find.descendant(
      of: find.byType(PaletteHuePicker),
      matching: find.byType(SliderPicker),
    );
    final slider = tester.widget<SliderPicker>(sliderFinder);
    final pink = Color.lerp(slider.colors![5], slider.colors![6], 0.5);
    final pinkHsv = HSVColor.fromColor(pink!);
    expect(pinkHsv.hue, closeTo(330, 1));
    expect(pinkHsv.saturation, closeTo(1, 0.001));
    expect(pinkHsv.value, closeTo(1, 0.001));

    final sliderRect = tester.getRect(sliderFinder);
    final gesture = await tester.startGesture(sliderRect.center);
    await gesture.moveTo(
      Offset(
        sliderRect.left + sliderRect.width * 330 / 360,
        sliderRect.center.dy,
      ),
    );
    await gesture.up();
    await tester.pump();

    expect(selected.hue, closeTo(330, 1));

    final paletteRect = tester.getRect(find.byType(PalettePicker));
    await tester.tapAt(Offset(paletteRect.right - 1, paletteRect.top + 1));
    await tester.pump();

    expect(selected.hue, closeTo(330, 1));
    expect(selected.saturation, closeTo(1, 0.01));
    expect(selected.value, closeTo(1, 0.01));
  });
}
