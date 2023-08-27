import 'package:flutter/material.dart';

import '../widgets/slider_picker.dart';
import '../widgets/slider_title.dart';

/// Three sliders for selections a color via:
/// Hue
/// Saturation
/// Value
class HSVPicker extends StatefulWidget {
  const HSVPicker({
    required this.color,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;

  @override
  State<HSVPicker> createState() => _HSVPickerState();
}

class _HSVPickerState extends State<HSVPicker> {
  HSVColor get color => widget.color;

  // Hue
  void hueOnChange(double value) => widget.onChanged(
        color.withHue(value),
      );
  List<Color> get hueColors => <Color>[
        color.withHue(0.0).toColor(),
        color.withHue(60.0).toColor(),
        color.withHue(120.0).toColor(),
        color.withHue(180.0).toColor(),
        color.withHue(240.0).toColor(),
        color.withHue(300.0).toColor(),
        color.withHue(0.0).toColor()
      ];

  // Saturation
  void saturationOnChange(double value) => widget.onChanged(
        color.withSaturation(value),
      );
  List<Color> get saturationColors => <Color>[
        color.withSaturation(0.0).toColor(),
        color.withSaturation(1.0).toColor()
      ];

  // Value
  void valueOnChange(double value) => widget.onChanged(
        color.withValue(value),
      );
  List<Color> get valueColors => <Color>[
        color.withValue(0.0).toColor(),
        color.withValue(1.0).toColor(),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Hue
        SliderTitle('H', '${color.hue.toInt()}º'),
        SliderPicker(
          value: color.hue,
          max: 360.0,
          onChanged: hueOnChange,
          colors: hueColors,
        ),

        // Saturation
        SliderTitle('S', '${(color.saturation * 100).toInt()}º'),
        SliderPicker(
          value: color.saturation,
          onChanged: saturationOnChange,
          colors: saturationColors,
        ),

        // Value
        SliderTitle('L', '${(color.value * 100).toInt()}º'),
        SliderPicker(
          value: color.value,
          onChanged: valueOnChange,
          colors: valueColors,
        )
      ],
    );
  }
}
