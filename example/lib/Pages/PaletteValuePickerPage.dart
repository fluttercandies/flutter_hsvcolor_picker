import "package:flutter/material.dart";
import "package:flutter_color_picker/flutter_color_picker.dart";
 
class PaletteValuePickerPage extends StatefulWidget {
   
  @override
  PaletteValuePickerPageState createState() => new PaletteValuePickerPageState();
}

class PaletteValuePickerPageState extends State<PaletteValuePickerPage> {
 
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
                             
                ///---------------------------------
                new PaletteValuePicker(
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
  