import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class SliderPickerPage extends StatefulWidget {
  const SliderPickerPage({Key? key}) : super(key: key);

  @override
  _SliderPickerPageState createState() => _SliderPickerPageState();
}

class _SliderPickerPageState extends State<SliderPickerPage> {
  final List<Color> hueColors = [
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255)
  ];

  double value = 0.0;
  void onChanged(double value) => this.value = value;

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
                  ((value * 100.0).toInt().toDouble() / 100.0).toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Divider(),

                ///---------------------------------
                SliderPicker(
                  min: 0.0,
                  max: 1.0,
                  value: value,
                  onChanged: (value) => super.setState(
                    () => onChanged(value),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: hueColors),
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
