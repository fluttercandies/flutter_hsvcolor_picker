import 'package:flutter/material.dart';

import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class WheelPickerPage extends StatefulWidget {
  const WheelPickerPage({Key? key}) : super(key: key);

  @override
  _WheelPickerPageState createState() => _WheelPickerPageState();
}

class _WheelPickerPageState extends State<WheelPickerPage> {
  HSVColor color = HSVColor.fromColor(Colors.blue);
  void onChanged(HSVColor color) => this.color = color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0.0),
            ),
          ),
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: color.toColor(),
                ),
                const Divider(),
                SizedBox(
                  width: 222,
                  height: 222,

                  ///---------------------------------
                  child: WheelPicker(
                    color: color,
                    onChanged: (value) => super.setState(
                      () => onChanged(value),
                    ),
                  ),
                )

                ///---------------------------------
              ],
            ),
          ),
        ),
      ),
    );
  }
}
