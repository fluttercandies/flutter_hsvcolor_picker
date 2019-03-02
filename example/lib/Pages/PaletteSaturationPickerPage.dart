import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
 
class PaletteSaturationPickerPage extends StatefulWidget {
   
  @override
  PaletteSaturationPickerPageState createState() => new PaletteSaturationPickerPageState();
}

class PaletteSaturationPickerPageState extends State<PaletteSaturationPickerPage> {
 
  HSVColor color =new HSVColor.fromColor(Colors.blue);
  void onChanged(HSVColor value) => this.color=value;
  
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
                  backgroundColor: this.color.toColor(),
                ),
                new Divider(),

                ///---------------------------------
                new PaletteSaturationPicker(
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
  