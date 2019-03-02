import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class HexPickerPage extends StatefulWidget { 
   
  @override
  HexPickerPageState createState() => new HexPickerPageState();
}

class HexPickerPageState extends State<HexPickerPage> {
   
  Color color =Colors.blue;
  void onChanged(Color value) => this.color=value;
  
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        width: 260,
        child: new Card(
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
          elevation: 2.0,
          child: new Padding(
            padding: const EdgeInsets.all(10),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new FloatingActionButton(
                  onPressed: (){},
                  backgroundColor: this.color,
                ),
                new Divider(),

                ///---------------------------------
                new HexPicker(     
                  color: this.color,
                  onChanged: (value)=>super.setState(()=>this.onChanged(value)),
                )
                ///---------------------------------
 
              ]
            )
          )
        )
      )
    );
  }
}
  