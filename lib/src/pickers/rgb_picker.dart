import 'package:flutter/material.dart';

import '../color_channels.dart';

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
        Color.fromARGB(color.alpha8, value.toInt(), color.green8, color.blue8),
      );
  List<Color> get redColors => <Color>[
        color.withRed(0),
        color.withRed(255),
      ];

  // Green
  void greenOnChange(double value) => widget.onChanged(
        Color.fromARGB(color.alpha8, color.red8, value.toInt(), color.blue8),
      );
  List<Color> get greenColors => <Color>[
        color.withGreen(0),
        color.withGreen(255),
      ];

  // Blue
  void blueOnChange(double value) => widget.onChanged(
        Color.fromARGB(
          color.alpha8,
          color.red8,
          color.green8,
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
          color.red8.toInt().toString(),
        ),
        SliderPicker(
          value: color.red8.toDouble(),
          max: 255.0,
          onChanged: redOnChange,
          colors: redColors,
        ),

        // Green
        SliderTitle(
          'G',
          color.green8.toInt().toString(),
        ),
        SliderPicker(
          value: color.green8.toDouble(),
          max: 255.0,
          onChanged: greenOnChange,
          colors: greenColors,
        ),

        // Blue
        SliderTitle(
          'B',
          color.blue8.toInt().toString(),
        ),
        SliderPicker(
          value: color.blue8.toDouble(),
          max: 255.0,
          onChanged: blueOnChange,
          colors: blueColors,
        )
      ],
    );
  }
}
