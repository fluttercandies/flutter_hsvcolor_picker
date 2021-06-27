import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter/cupertino.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({Key? key}) : super(key: key);

  @override
  ColorPickerPageState createState() => ColorPickerPageState();
}

class ColorPickerPageState extends State<ColorPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1.0),
            ),
          ),
          elevation: 4.0,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
            child: ColorPicker(color: Colors.blue, onChanged: (value) {}),
          ),
        ),
      ),
    );
  }
}
