import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_hsvcolor_picker_example/complex_example/main.dart' as example;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('detailed color picker stays usable above the keyboard', (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const example.MyApp());
    await tester.enterText(find.byType(TextField), 'FF0000');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('detailed example loads its avatar and every picker destination', (tester) async {
    rootBundle.evict('packages/Avatar.jpg');
    final avatar = await tester.runAsync(() => rootBundle.load('packages/Avatar.jpg'));
    expect(avatar!.lengthInBytes, greaterThan(0));
    await tester.pumpWidget(const example.MyApp());
    final destinations = <String, Type>{
      'Color Picker': ColorPicker,
      'RGB Picker': RGBPicker,
      'HSV Picker': HSVPicker,
      'Wheel Picker': WheelPicker,
      'Palette Hue Picker': PaletteHuePicker,
      'Palette Saturation Picker': PaletteSaturationPicker,
      'Palette Value Picker': PaletteValuePicker,
      'Swatches Picker': SwatchesPicker,
      'Hex Picker': HexPicker,
      'Alpha Picker': AlphaPicker,
      'Slider': SliderPicker,
      'Palette': PalettePicker,
    };
    for (final destination in destinations.entries) {
      await tester.tap(find.byIcon(Icons.dehaze).first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text(destination.key), 80,
          scrollable: find.descendant(of: find.byType(Drawer), matching: find.byType(Scrollable)).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(destination.key));
      await tester.pumpAndSettle();
      expect(find.byType(destination.value), findsWidgets);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
