import 'package:flutter/material.dart';

import '../widgets/palette_picker.dart';
import '../widgets/slider_picker.dart';

class PaletteValuePicker extends StatefulWidget {
  const PaletteValuePicker({
    required this.color,
    required this.onChanged,
    this.paletteHeight = 280,
    Key? key,
  }) : super(key: key);

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final double paletteHeight;

  @override
  State<PaletteValuePicker> createState() => _PaletteValuePickerState();
}

class _PaletteValuePickerState extends State<PaletteValuePicker> {
  HSVColor get color => widget.color;

  // Value
  void valueOnChange(double value) => widget.onChanged(
        color.withValue(value),
      );
  List<Color> get valueColors => <Color>[
        Colors.black,
        color.withValue(1.0).toColor(),
      ];

  // Hue Saturation
  void hueSaturationOnChange(Offset value) => widget.onChanged(
        HSVColor.fromAHSV(color.alpha, value.dx, value.dy, color.value),
      );
  // Hue
  final List<Color> hueColors = <Color>[
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255),
    const Color.fromARGB(255, 255, 0, 0)
  ];
  // Saturation
  final List<Color> saturationColors = <Color>[
    Colors.transparent,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Palette
        SizedBox(
          height: widget.paletteHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: PalettePicker(
              position: Offset(color.hue, color.saturation),
              onChanged: hueSaturationOnChange,
              rightPosition: 360.0,
              leftRightColors: hueColors,
              topPosition: 1.0,
              bottomPosition: 0.0,
              topBottomColors: saturationColors,
            ),
          ),
        ),

        // Slider
        SliderPicker(
          value: color.value,
          onChanged: valueOnChange,
          colors: valueColors,
        )
      ],
    );
  }
}
