import 'package:flutter/material.dart';

import 'slider_picker.dart';

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
  _HSVPickerState createState() => _HSVPickerState();
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

  Widget buildTitle(String title, String text) {
    return SizedBox(
      height: 34.0,
      child: Row(
        children: <Widget>[
          Opacity(
            opacity: 0.5,
            child: Text(title, style: Theme.of(context).textTheme.headline6),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Hue
        buildTitle('H', '${color.hue.toInt()}º'),
        SliderPicker(
          value: color.hue,
          max: 360.0,
          onChanged: hueOnChange,
          colors: hueColors,
        ),

        // Saturation
        buildTitle('S', '${(color.saturation * 100).toInt()}º'),
        SliderPicker(
          value: color.saturation,
          onChanged: saturationOnChange,
          colors: saturationColors,
        ),

        // Value
        buildTitle('L', '${(color.value * 100).toInt()}º'),
        SliderPicker(
          value: color.value,
          onChanged: valueOnChange,
          colors: valueColors,
        )
      ],
    );
  }
}
