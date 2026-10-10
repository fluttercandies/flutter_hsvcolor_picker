import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final input in ['ff0000', '#ff0000', '0xFF0000', '  #FF0000  ']) {
    testWidgets('submits RGB hex input $input', (tester) async {
      final colors = <Color>[];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: HexPicker(color: Colors.blue, onChanged: colors.add)),
      ));
      await tester.enterText(find.byType(TextField), input);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(tester.takeException(), isNull);
      expect(colors, [const Color(0xffff0000)]);
    });
  }

  testWidgets('long invalid input keeps the current color without throwing',
      (tester) async {
    final colors = <Color>[];
    await tester.pumpWidget(MaterialApp(
      home:
          Scaffold(body: HexPicker(color: Colors.blue, onChanged: colors.add)),
    ));
    await tester.enterText(find.byType(TextField), 'this is not a hex color');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(tester.takeException(), isNull);
    expect(colors, [Colors.blue]);
  });

  testWidgets(
      'rebuilding with the same color preserves editing and focus resources',
      (tester) async {
    Widget app() => MaterialApp(
          home:
              Scaffold(body: HexPicker(color: Colors.blue, onChanged: (_) {})),
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

  testWidgets('parent color changes update the active picker', (tester) async {
    Widget app(Color color) => MaterialApp(
          home: Scaffold(body: ColorPicker(color: color, onChanged: (_) {})),
        );
    await tester.pumpWidget(app(const Color(0xffff0000)));
    await tester.pumpWidget(app(const Color(0xff00ff00)));
    expect(
        tester
            .widget<PaletteHuePicker>(find.byType(PaletteHuePicker))
            .color
            .hue,
        120);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '00FF00');
  });
}
