import 'package:flutter/material.dart';

import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

// For a more detailed example, head over to:
// https://github.com/fluttercandies/flutter_hsvcolor_picker/tree/master/example/lib/complex_example

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _colorNotifier = ValueNotifier<Color>(Colors.green);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: ValueListenableBuilder<Color>(
            valueListenable: _colorNotifier,
            builder: (_, color, __) {
              return ColorPicker(
                color: color,
                onChanged: (value) => color = value,
              );
            },
          ),
        ),
      ),
    );
  }
}
