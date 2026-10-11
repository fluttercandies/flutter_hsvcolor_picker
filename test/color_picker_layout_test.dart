import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final picker in Picker.values) {
    testWidgets('layout changes preserve HEX editing in ${picker.name}', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1100);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final colors = <Color>[];
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ColorPicker(color: Colors.blue, initialPicker: picker, onChanged: colors.add),
          ),
        ),
      ));
      final field = find.byType(TextField);
      await tester.enterText(field, '12');
      tester.testTextInput.updateEditingValue(const TextEditingValue(
        text: '12',
        selection: TextSelection(baseOffset: 0, extentOffset: 2),
        composing: TextRange(start: 0, end: 2),
      ));
      await tester.pump();
      final before = tester.widget<TextField>(field);
      final draft = before.controller!.value;

      for (final size in [const Size(800, 600), const Size(800, 1100)]) {
        tester.view.physicalSize = size;
        await tester.pumpAndSettle();

        final after = tester.widget<TextField>(field);
        expect(after.controller, same(before.controller));
        expect(after.focusNode, same(before.focusNode));
        expect(after.controller!.value, draft);
        expect(after.focusNode!.hasFocus, isTrue);
        expect(colors, isEmpty);
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
