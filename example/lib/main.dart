import 'package:flutter/material.dart';

import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

// For a more detailed example, head over to:
// https://github.com/fluttercandies/flutter_hsvcolor_picker/example/lib/complex_example

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
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
  // Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: ColorPicker(
            // color: _color,
            onChanged: (Color value) {
              // _color = value;
              // setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
