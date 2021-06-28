import 'package:flutter/material.dart';

import 'palette_picker.dart';
import 'slider_picker.dart';

/// Color palette and color slider
class PaletteHuePicker extends StatefulWidget {
  const PaletteHuePicker({
    required this.color,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;

  @override
  _PaletteHuePickerState createState() => _PaletteHuePickerState();
}

class _PaletteHuePickerState extends State<PaletteHuePicker> {
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

  // Saturation Value
  void saturationValueOnChange(Offset value) => widget.onChanged(
        HSVColor.fromAHSV(color.alpha, color.hue, value.dx, value.dy),
      );
  // Saturation
  List<Color> get saturationColors => <Color>[
        Colors.white,
        HSVColor.fromAHSV(1.0, color.hue, 1.0, 1.0).toColor(),
      ];
  // Value
  final List<Color> valueColors = <Color>[
    Colors.transparent,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Palette
        SizedBox(
          height: 280.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: PalettePicker(
              position: Offset(color.saturation, color.value),
              onChanged: saturationValueOnChange,
              leftRightColors: saturationColors,
              topPosition: 1.0,
              bottomPosition: 0.0,
              topBottomColors: valueColors,
            ),
          ),
        ),

        // Slider
        SliderPicker(
          max: 360.0,
          value: color.hue,
          onChanged: hueOnChange,
          colors: hueColors,
        )
      ],
    );
  }
}
