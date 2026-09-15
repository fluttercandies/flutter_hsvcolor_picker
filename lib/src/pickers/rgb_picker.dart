import 'package:flutter/material.dart';

import '../widgets/slider_picker.dart';
import '../widgets/slider_title.dart';

int _colorChannel(Color color, int shift) => (color.toARGB32() >> shift) & 0xff;

/// Three sliders for selecting a color based on RGB.
class RGBPicker extends StatefulWidget {
  const RGBPicker({
    required this.color,
    required this.onChanged,
    super.key,
  });

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<RGBPicker> createState() => _RGBPickerState();
}

class _RGBPickerState extends State<RGBPicker> {
  Color get color => widget.color;
  int get alpha => _colorChannel(color, 24);
  int get red => _colorChannel(color, 16);
  int get green => _colorChannel(color, 8);
  int get blue => _colorChannel(color, 0);

  // Red
  void redOnChange(double value) => widget.onChanged(
        Color.fromARGB(alpha, value.toInt(), green, blue),
      );
  List<Color> get redColors => <Color>[
        color.withRed(0),
        color.withRed(255),
      ];

  // Green
  void greenOnChange(double value) => widget.onChanged(
        Color.fromARGB(alpha, red, value.toInt(), blue),
      );
  List<Color> get greenColors => <Color>[
        color.withGreen(0),
        color.withGreen(255),
      ];

  // Blue
  void blueOnChange(double value) => widget.onChanged(
        Color.fromARGB(
          alpha,
          red,
          green,
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
          red.toString(),
        ),
        SliderPicker(
          value: red.toDouble(),
          max: 255.0,
          onChanged: redOnChange,
          colors: redColors,
        ),

        // Green
        SliderTitle(
          'G',
          green.toString(),
        ),
        SliderPicker(
          value: green.toDouble(),
          max: 255.0,
          onChanged: greenOnChange,
          colors: greenColors,
        ),

        // Blue
        SliderTitle(
          'B',
          blue.toString(),
        ),
        SliderPicker(
          value: blue.toDouble(),
          max: 255.0,
          onChanged: blueOnChange,
          colors: blueColors,
        )
      ],
    );
  }
}
