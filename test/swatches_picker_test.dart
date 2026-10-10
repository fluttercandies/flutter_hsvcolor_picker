import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

void main() {
  testWidgets('the last swatch remains reachable and selects its color',
      (tester) async {
    Color? selected;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: SwatchesPicker(onChanged: (color) => selected = color),
        ),
      ),
    ));
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
    await tester.pumpAndSettle();
    final lastSwatch = find.byWidgetPredicate((widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration! as BoxDecoration).color ==
            Colors.blueGrey.shade900);
    expect(lastSwatch, findsOneWidget);
    await tester.tap(lastSwatch);
    expect(selected, Colors.blueGrey.shade900);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
