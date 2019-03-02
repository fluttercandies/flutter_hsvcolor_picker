import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter/cupertino.dart';

class ColorPickerPage extends StatefulWidget {
   
  @override
  ColorPickerPageState createState() => new ColorPickerPageState();
}

class ColorPickerPageState extends State<ColorPickerPage> {

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        width: 300,
        child: new Card(
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(1.0))),
          elevation: 4.0,
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
            child: new ColorPicker(
              color: Colors.blue,
              onChanged: (value){ }
            )
          )
        )
      )
    );
  }
}
  