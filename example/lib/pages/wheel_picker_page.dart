import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class WheelPickerPage extends StatefulWidget {
  const WheelPickerPage({Key? key}) : super(key: key);

  @override
  WheelPickerPageState createState() => WheelPickerPageState();
}

class WheelPickerPageState extends State<WheelPickerPage> {
  HSVColor color = HSVColor.fromColor(Colors.blue);
  void onChanged(HSVColor color) => this.color = color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
                  backgroundColor: this.color.toColor(),
                ),
                const Divider(),

                ///---------------------------------
                Container(
                  width: 222,
                  height: 222,
                  child: WheelPicker(
                    color: this.color,
                    onChanged: (value) => super.setState(
                      () => this.onChanged(value),
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
