import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final picker in [Picker.paletteSaturation, Picker.paletteValue]) {
    testWidgets('selected $picker label stays inside a narrow dropdown', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 177,
              child: ColorPicker(
                initialPicker: picker,
                pickerOrientation: PickerOrientation.portrait,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      ));
      final dropdown = find.byWidgetPredicate((widget) => widget is DropdownButton);
      final name = picker == Picker.paletteSaturation ? 'Palette Saturation' : 'Palette Value';
      final label = find.text(name);
      expect(label, findsOneWidget);
      final paragraph = tester.renderObject<RenderParagraph>(label);
      final origin = tester.getTopLeft(label);
      final bottom = tester.getRect(dropdown).bottom;
      final boxes = paragraph.getBoxesForSelection(TextSelection(baseOffset: 0, extentOffset: name.length));
      expect(boxes, isNotEmpty);
      for (final box in boxes) {
        expect(origin.dy + box.bottom, lessThanOrEqualTo(bottom),
            reason: 'The selected label must not wrap below its button.');
      }
      expect(tester.takeException(), isNull);
    });
  }
}
