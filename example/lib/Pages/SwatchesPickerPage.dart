import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class SwatchesPickerPage extends StatefulWidget {
   
  @override
  SwatchesPickerPageState createState() => new SwatchesPickerPageState();
}

class SwatchesPickerPageState extends State<SwatchesPickerPage> {

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
            child: new SwatchesPicker(
              onChanged: (value){ }
            )
          )
        )
      )
    );
  }
}
  