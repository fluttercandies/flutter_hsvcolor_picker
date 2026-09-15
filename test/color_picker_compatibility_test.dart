import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HexPicker displays the exact RGB channels', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HexPicker(
            color: const Color.fromARGB(0x7f, 0x0a, 0xb0, 0xff),
            onChanged: (_) {},
          ),
        ),
      ),
    );

    final textField = tester.widget<TextField>(find.byType(TextField));

    expect(textField.controller?.text, '0AB0FF');
  });

  testWidgets('RGBPicker reports changed channels without altering the others', (tester) async {
    Color? changedColor;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RGBPicker(
            color: const Color.fromARGB(0x7f, 0x12, 0x34, 0x56),
            onChanged: (color) => changedColor = color,
          ),
        ),
      ),
    );

    final sliders = tester.widgetList<SliderPicker>(find.byType(SliderPicker)).toList();

    expect(sliders, hasLength(3));
    expect(sliders[0].value, 0x12);
    expect(sliders[1].value, 0x34);
    expect(sliders[2].value, 0x56);

    sliders[0].onChanged(0xab);
    expect(changedColor, isSameColorAs(const Color.fromARGB(0x7f, 0xab, 0x34, 0x56)));

    sliders[1].onChanged(0xcd);
    expect(changedColor, isSameColorAs(const Color.fromARGB(0x7f, 0x12, 0xcd, 0x56)));

    sliders[2].onChanged(0xef);
    expect(changedColor, isSameColorAs(const Color.fromARGB(0x7f, 0x12, 0x34, 0xef)));
  });

  testWidgets('ColorPicker preserves alpha across RGB changes', (tester) async {
    final changedColors = <Color>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColorPicker(
            color: const Color.fromARGB(0x55, 1, 2, 3),
            initialPicker: Picker.rgb,
            pickerOrientation: PickerOrientation.portrait,
            onChanged: changedColors.add,
          ),
        ),
      ),
    );

    tester.widget<RGBPicker>(find.byType(RGBPicker)).onChanged(const Color.fromARGB(0xff, 9, 8, 7));
    await tester.pump();

    expect(changedColors.last, isSameColorAs(const Color.fromARGB(0x55, 9, 8, 7)));

    tester.widget<AlphaPicker>(find.byType(AlphaPicker)).onChanged(0x22);
    await tester.pump();

    expect(changedColors.last, isSameColorAs(const Color.fromARGB(0x22, 9, 8, 7)));
  });

  testWidgets('ColorPicker preserves alpha across HSV changes', (tester) async {
    final changedColors = <Color>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ColorPicker(
            color: const Color.fromARGB(0x55, 1, 2, 3),
            initialPicker: Picker.hsv,
            pickerOrientation: PickerOrientation.portrait,
            onChanged: changedColors.add,
          ),
        ),
      ),
    );

    tester.widget<HSVPicker>(find.byType(HSVPicker)).onChanged(
          HSVColor.fromColor(const Color.fromARGB(0xff, 9, 8, 7)),
        );
    await tester.pump();

    expect(changedColors.single, isSameColorAs(const Color.fromARGB(0x55, 9, 8, 7)));
  });

  testWidgets('SliderPicker positions its thumb at the selected ratio', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: SliderPicker(value: 0.5, onChanged: (_) {}),
            ),
          ),
        ),
      ),
    );

    final transform = tester.widget<Transform>(
      find.descendant(of: find.byType(SliderPicker), matching: find.byType(Transform)),
    );

    expect(transform.transform.storage[12], 100);
    expect(transform.transform.storage[13], 0);
    expect(transform.transform.storage[14], 0);
  });
}
