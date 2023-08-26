import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class AlphaPickerPage extends StatefulWidget {
  const AlphaPickerPage({Key? key}) : super(key: key);

  @override
  _AlphaPickerPageState createState() => _AlphaPickerPageState();
}

class _AlphaPickerPageState extends State<AlphaPickerPage> {
  int value = 0;
  void onChanged(int value) => this.value = value;

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
                Text(
                  value.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Divider(),

                ///---------------------------------
                AlphaPicker(
                  alpha: value,
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
