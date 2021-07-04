import 'package:flutter/material.dart';

import 'alpha_picker.dart';
import 'hex_picker.dart';
import 'hsv_picker.dart';
import 'palette_hue_picker.dart';
import 'palette_saturation_picker.dart';
import 'palette_value_picker.dart';
import 'rgb_picker.dart';
import 'swatches_picker.dart';
import 'wheel_picker.dart';

enum Picker {
  swatches,
  rgb,
  hsv,
  wheel,
  paletteHue,
  paletteSaturation,
  paletteValue,
}

/// Main color picker including all color pickers of this package
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    required this.onChanged,
    this.color = Colors.blue,
    this.initialPicker = Picker.paletteHue,
    Key? key,
  }) : super(key: key);

  final ValueChanged<Color> onChanged;
  final Color color;

  /// The first picker widget that is shown.
  ///
  /// See also:
  ///
  ///  * [Picker] Enumeration of pickers.
  final Picker initialPicker;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  _ColorPickerState();

  // Color
  late int _alpha;
  late Color _color;
  late HSVColor _hSVColor;
  late List<_IPicker> _pickers;
  late int _index;

  void _alphaOnChanged(int value) {
    _alpha = value;
    _color = _color.withAlpha(_alpha);
    widget.onChanged(_color);
  }

  void _colorOnChanged(Color value) {
    _color = value;
    _hSVColor = HSVColor.fromColor(value);
    widget.onChanged(value);
  }

  void _hSVColorOnChanged(HSVColor value) {
    _color = value.toColor();
    _hSVColor = value;
    widget.onChanged(value.toColor());
  }

  void _colorWithAlphaOnChanged(Color value) {
    _alpha = value.alpha;
    final Color color = value.withAlpha(255);
    _color = color;
    _hSVColor = HSVColor.fromColor(color);
    widget.onChanged(value);
  }

  void _pickerOnChanged(_IPicker? value) {
    if (value != null) {
      _index = _pickers.indexOf(value);
    } else {
      _index = -1;
    }
  }

  @override
  void initState() {
    super.initState();

    _color = widget.color;
    _alpha = _color.alpha;
    _hSVColor = HSVColor.fromColor(_color);

    // Pickers
    _pickers = <_IPicker>[
      // SwatchesPicker
      _IPicker(
        name: 'Swatches',
        picker: Picker.swatches,
        builder: (BuildContext context) => SwatchesPicker(
          onChanged: (Color value) => super.setState(
            () => _colorWithAlphaOnChanged(value),
          ),
        ),
      ),

      // RGBPicker
      _IPicker(
        name: 'RGB',
        picker: Picker.rgb,
        builder: (BuildContext context) => RGBPicker(
          color: _color,
          onChanged: (Color value) => super.setState(
            () => _colorOnChanged(value),
          ),
        ),
      ),

      // HSVPicker
      _IPicker(
        name: 'HSV',
        picker: Picker.hsv,
        builder: (BuildContext context) => HSVPicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // WheelPicker
      _IPicker(
        name: 'Wheel',
        picker: Picker.wheel,
        builder: (BuildContext context) => WheelPicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // PaletteHuePicker
      _IPicker(
        name: 'Palette Hue',
        picker: Picker.paletteHue,
        builder: (BuildContext context) => PaletteHuePicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // PaletteSaturationPicker
      _IPicker(
        name: 'Palette Saturation',
        picker: Picker.paletteSaturation,
        builder: (BuildContext context) => PaletteSaturationPicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // PaletteValuePicker
      _IPicker(
        name: 'Palette Value',
        picker: Picker.paletteValue,
        builder: (BuildContext context) => PaletteValuePicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),
    ];

    _index = _pickers.indexOf(
      _pickers.firstWhere((element) => element.picker == widget.initialPicker),
    );
  }

  // Dropdown
  DropdownMenuItem<_IPicker> _buildDropdownMenuItems(_IPicker item) {
    return DropdownMenuItem<_IPicker>(
      value: item,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0.0),
        child: Text(
          item.name,
          style: _index == _pickers.indexOf(item)
              ? Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 18, color: Theme.of(context).accentColor)
              : Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildHead() {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Avator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                color: _color,
              ),
            ),
          ),

          const SizedBox(width: 22),

          // HexPicker
          Expanded(
            child: HexPicker(
              color: _color,
              onChanged: (Color value) => super.setState(
                () => _colorOnChanged(value),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return SizedBox(
      height: 38,
      child: Material(
        type: MaterialType.button,
        color: Theme.of(context).cardColor,
        shadowColor: Colors.black26,
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(2.0),
          ),
        ),
        child: DropdownButton<_IPicker>(
          iconSize: 32.0,
          isExpanded: true,
          isDense: true,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
          value: _pickers[_index],
          onChanged: (_IPicker? value) => super.setState(
            () => _pickerOnChanged(value),
          ),
          items: _pickers.map(_buildDropdownMenuItems).toList(),
        ),
      ),
    );
  }

  Widget _buildDropdown2() {
    return SizedBox(
      height: 38,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(3.0),
          ),
        ),
        child: DropdownButton<_IPicker>(
          iconSize: 32.0,
          isExpanded: true,
          isDense: true,
          style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 20),
          value: _pickers[_index],
          onChanged: (_IPicker? value) => super.setState(
            () => _pickerOnChanged(value),
          ),
          items: _pickers.map(_buildDropdownMenuItems).toList(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SizedBox(
      child: _pickers[_index].builder(context),
    );
  }

  Widget _buildAlphaPicker() {
    return AlphaPicker(
      alpha: _alpha,
      onChanged: (int value) => super.setState(
        () => _alphaOnChanged(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.portrait:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHead(),
            _buildDropdown2(),
            _buildBody(),
            _buildAlphaPicker(),
          ],
        );

      case Orientation.landscape:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildHead(),
                  _buildDropdown(),
                  _buildAlphaPicker(),
                ],
              ),
            ),
            Expanded(
              child: _buildBody(),
            )
          ],
        );
    }
  }
}

class _IPicker {
  _IPicker({
    required this.name,
    required this.picker,
    required this.builder,
  });

  String name;
  Picker picker;
  WidgetBuilder builder;
}
