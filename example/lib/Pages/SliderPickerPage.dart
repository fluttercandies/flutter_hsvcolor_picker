import "package:flutter/material.dart";
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class SliderPickerPage extends StatefulWidget {
    
  @override
  SliderPickerPageState createState() => new SliderPickerPageState();
}

class SliderPickerPageState extends State<SliderPickerPage> {
   
  final List<Color> hueColors=[
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255)   
  ];  

  double value =0.0;
  void onChanged(double value) => this.value=value;
  
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
                  ((this.value*100.0).toInt().toDouble()/100.0).toString(),
                  style: Theme.of(context).textTheme.headline4,
                ),
                new Divider(),

                ///---------------------------------
                new SliderPicker(     
                  min: 0.0,
                  max: 1.0,
                  value: this.value,
                  onChanged: (value)=>super.setState(()=>this.onChanged(value)),
                  child: new DecoratedBox(
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(colors: this.hueColors)
                    )
                  )
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
  