import 'package:flutter/material.dart';

import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class HexPickerPage extends StatefulWidget {
  const HexPickerPage({Key? key}) : super(key: key);

  @override
  _HexPickerPageState createState() => _HexPickerPageState();
}

class _HexPickerPageState extends State<HexPickerPage> {
  Color color = Colors.blue;
  void onChanged(Color value) => color = value;

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
                  backgroundColor: color,
                ),
                const Divider(),

                ///---------------------------------
                HexPicker(
                  color: color,
                  onChanged: (value) => super.setState(
                    () => onChanged(value),
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
