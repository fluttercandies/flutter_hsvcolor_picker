import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final input in ['ff0000', '#ff0000', '0xFF0000', '  #FF0000  ']) {
    testWidgets('submits RGB hex input $input', (tester) async {
      final colors = <Color>[];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: HexPicker(color: Colors.blue, onChanged: colors.add)),
      ));
      await tester.enterText(find.byType(TextField), input);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(tester.takeException(), isNull);
      expect(colors, [const Color(0xffff0000)]);
    });
  }

  testWidgets('long invalid input keeps the current color without throwing', (tester) async {
    final colors = <Color>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: HexPicker(color: Colors.blue, onChanged: colors.add)),
    ));
    await tester.enterText(find.byType(TextField), 'this is not a hex color');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(tester.takeException(), isNull);
    expect(colors, [Colors.blue]);
  });

  testWidgets('rebuilding with the same color preserves editing and focus resources', (tester) async {
    Widget app() => MaterialApp(
          home: Scaffold(body: HexPicker(color: Colors.blue, onChanged: (_) {})),
        );
    await tester.pumpWidget(app());
    await tester.enterText(find.byType(TextField), '123');
    final before = tester.widget<TextField>(find.byType(TextField));
    await tester.pumpWidget(app());
    final after = tester.widget<TextField>(find.byType(TextField));
    expect(after.controller, same(before.controller));
    expect(after.focusNode, same(before.focusNode));
    expect(after.controller!.text, '123');
  });

  for (final isFocused in [true, false]) {
    testWidgets('alpha-only color changes preserve ${isFocused ? 'focused' : 'unfocused'} HEX input', (tester) async {
      Widget app(Color color) => MaterialApp(
            home: Scaffold(body: HexPicker(color: color, onChanged: (_) {})),
          );
      await tester.pumpWidget(app(const Color(0xff112233)));
      await tester.enterText(find.byType(TextField), '12');
      tester.testTextInput.updateEditingValue(const TextEditingValue(
        text: '12',
        selection: TextSelection(baseOffset: 0, extentOffset: 2),
        composing: TextRange(start: 0, end: 2),
      ));
      await tester.pump();
      final before = tester.widget<TextField>(find.byType(TextField));
      if (!isFocused) {
        before.focusNode!.unfocus();
        await tester.pump();
      }
      final editingValue = before.controller!.value;

      await tester.pumpWidget(app(const Color(0x40112233)));

      final after = tester.widget<TextField>(find.byType(TextField));
      expect(after.controller, same(before.controller));
      expect(after.focusNode, same(before.focusNode));
      expect(after.controller!.value, editingValue);
      expect(after.focusNode!.hasFocus, isFocused);
      expect(tester.takeException(), isNull);
    });
  }

  for (final picker in Picker.values) {
    testWidgets('alpha slider preserves unfinished HEX edits in ${picker.name}', (tester) async {
      final colors = <Color>[];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: ColorPicker(
              color: Colors.blue,
              initialPicker: picker,
              pickerOrientation: PickerOrientation.portrait,
              onChanged: colors.add,
            ),
          ),
        ),
      ));
      await tester.enterText(find.byType(TextField), '12');
      final before = tester.widget<TextField>(find.byType(TextField));
      final editingValue = before.controller!.value;
      final alphaSlider = find.descendant(of: find.byType(AlphaPicker), matching: find.byType(SliderPicker));

      await tester.tapAt(tester.getCenter(alphaSlider));
      await tester.pump();

      final alpha = tester.widget<AlphaPicker>(find.byType(AlphaPicker)).alpha;
      final after = tester.widget<TextField>(find.byType(TextField));
      expect(alpha, isNot(255));
      expect(colors, [Colors.blue.withAlpha(alpha)]);
      expect(after.controller!.value, editingValue);
      expect(after.focusNode, same(before.focusNode));

      await tester.enterText(find.byType(TextField), '112233');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(colors.last, const Color(0xff112233).withAlpha(alpha));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('RGB changes replace a focused HEX draft', (tester) async {
    Widget app(Color color) => MaterialApp(
          home: Scaffold(body: HexPicker(color: color, onChanged: (_) {})),
        );
    await tester.pumpWidget(app(const Color(0xff112233)));
    await tester.enterText(find.byType(TextField), '12');
    final before = tester.widget<TextField>(find.byType(TextField));

    await tester.pumpWidget(app(const Color(0x400033ff)));

    final after = tester.widget<TextField>(find.byType(TextField));
    expect(after.controller, same(before.controller));
    expect(after.focusNode, same(before.focusNode));
    expect(after.controller!.text, '0033FF');
    expect(after.controller!.selection, const TextSelection.collapsed(offset: 6));
    expect(after.controller!.value.composing, TextRange.empty);
    expect(after.focusNode!.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('parent color changes update the active picker', (tester) async {
    Widget app(Color color) => MaterialApp(
          home: Scaffold(body: ColorPicker(color: color, onChanged: (_) {})),
        );
    await tester.pumpWidget(app(const Color(0xffff0000)));
    await tester.pumpWidget(app(const Color(0xff00ff00)));
    expect(tester.widget<PaletteHuePicker>(find.byType(PaletteHuePicker)).color.hue, 120);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, '00FF00');
  });
}
