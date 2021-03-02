import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class PalettePickerPage extends StatefulWidget {
 
  final List<Color> horizontalColors=[Colors.white, Colors.blue];  
  final List<Color> verticalColors=[Colors.transparent, Colors.black];    
    
  @override
  PalettePickerPageState createState() => new PalettePickerPageState();
}

class PalettePickerPageState extends State<PalettePickerPage> {

  Offset value =Offset.zero;         
  void onChanged(Offset value) => this.value=value;
  
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        width: 260,
        height: 320,
        child: new Card(
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
          elevation: 2.0,
          child: new Padding(
            padding: const EdgeInsets.all(10),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  "( "+
                  ((this.value.dx*100.0).toInt().toDouble()/100.0).toString()+
                  " , "+
                  ((this.value.dy*100.0).toInt().toDouble()/100.0).toString()+
                  " )",
                  style: Theme.of(context).textTheme.headline4,
                ),
                new Divider(),
                new Expanded(


                ///---------------------------------
                child: new PalettePicker(     
                  topPosition: 1.0,
                  bottomPosition: 0.0,
                  position: this.value,
                  onChanged: (value)=>super.setState(()=>this.onChanged(value)),
                  leftRightColors: super.widget.horizontalColors,
                  topBottomColors: super.widget.verticalColors
                )
                ///---------------------------------

                )
              ]
            )
          )
        )
      )
    );
  }
}
  