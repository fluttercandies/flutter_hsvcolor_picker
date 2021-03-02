import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class AlphaPickerPage extends StatefulWidget {

  @override
  AlphaPickerPageState createState() => new AlphaPickerPageState();
}

class AlphaPickerPageState extends State<AlphaPickerPage> {
    
  int value =0;
  void onChanged(int value) => this.value=value;
  
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
                new Text(
                  this.value.toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
                new Divider(),

                ///---------------------------------
                new AlphaPicker(     
                  alpha: this.value,
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
  