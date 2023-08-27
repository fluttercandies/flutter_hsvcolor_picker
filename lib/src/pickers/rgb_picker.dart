import 'package:flutter/material.dart';

import '../widgets/slider_picker.dart';
import '../widgets/slider_title.dart';

/// Three sliders for selecting a color based on RGB.
class RGBPicker extends StatefulWidget {
  const RGBPicker({
    required this.color,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<RGBPicker> createState() => _RGBPickerState();
}

class _RGBPickerState extends State<RGBPicker> {
  Color get color => widget.color;

  // Red
  void redOnChange(double value) => widget.onChanged(
        Color.fromARGB(color.alpha, value.toInt(), color.green, color.blue),
      );
  List<Color> get redColors => <Color>[
        color.withRed(0),
        color.withRed(255),
      ];

  // Green
  void greenOnChange(double value) => widget.onChanged(
        Color.fromARGB(color.alpha, color.red, value.toInt(), color.blue),
      );
  List<Color> get greenColors => <Color>[
        color.withGreen(0),
        color.withGreen(255),
      ];

  // Blue
  void blueOnChange(double value) => widget.onChanged(
        Color.fromARGB(
          color.alpha,
          color.red,
          color.green,
          value.toInt(),
        ),
      );
  List<Color> get blueColors => <Color>[
        color.withBlue(0),
        color.withBlue(255),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Red
        SliderTitle(
          'R',
          color.red.toInt().toString(),
        ),
        SliderPicker(
          value: color.red.toDouble(),
          max: 255.0,
          onChanged: redOnChange,
          colors: redColors,
        ),

        // Green
        SliderTitle(
          'G',
          color.green.toInt().toString(),
        ),
        SliderPicker(
          value: color.green.toDouble(),
          max: 255.0,
          onChanged: greenOnChange,
          colors: greenColors,
        ),

        // Blue
        SliderTitle(
          'B',
          color.blue.toInt().toString(),
        ),
        SliderPicker(
          value: color.blue.toDouble(),
          max: 255.0,
          onChanged: blueOnChange,
          colors: blueColors,
        )
      ],
    );
  }
}
