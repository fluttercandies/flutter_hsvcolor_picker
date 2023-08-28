import 'package:flutter/material.dart';

import '../widgets/palette_picker.dart';
import '../widgets/slider_picker.dart';

class PaletteSaturationPicker extends StatefulWidget {
  const PaletteSaturationPicker({
    required this.color,
    required this.onChanged,
    this.paletteHeight = 280,
    Key? key,
  }) : super(key: key);

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final double paletteHeight;

  @override
  State<PaletteSaturationPicker> createState() =>
      _PaletteSaturationPickerState();
}

class _PaletteSaturationPickerState extends State<PaletteSaturationPicker> {
  HSVColor get color => widget.color;

  // Saturation
  void saturationOnChange(double value) => widget.onChanged(
        color.withSaturation(value),
      );
  List<Color> get saturationColors => <Color>[
        color.withSaturation(0.0).toColor(),
        color.withSaturation(1.0).toColor()
      ];

  // Hue Value
  Offset get hueValueOffset => Offset(color.hue, color.value);
  void hueValueOnChange(Offset value) => widget.onChanged(
        HSVColor.fromAHSV(color.alpha, value.dx, color.saturation, value.dy),
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
          height: widget.paletteHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: PalettePicker(
              position: hueValueOffset,
              onChanged: hueValueOnChange,
              rightPosition: 360.0,
              leftRightColors: hueColors,
              topPosition: 1.0,
              bottomPosition: 0.0,
              topBottomColors: valueColors,
            ),
          ),
        ),

        // Slider
        SliderPicker(
          value: color.saturation,
          onChanged: saturationOnChange,
          colors: saturationColors,
        )
      ],
    );
  }
}
