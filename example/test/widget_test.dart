import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_hsvcolor_picker_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('example retains the selected color in parent state', (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byType(TextField), 'FF0000');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(tester.widget<ColorPicker>(find.byType(ColorPicker)).color, const Color(0xffff0000));
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });
}
