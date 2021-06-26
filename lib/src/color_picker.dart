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

class _IPicker {
  _IPicker({
    required this.index,
    required this.name,
    required this.builder,
  });

  int index;
  String name;
  WidgetBuilder builder;
}

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    required this.onChanged,
    this.color = Colors.blue,
    Key? key,
  }) : super(key: key);

  final ValueChanged<Color> onChanged;
  final Color color;

  @override
  ColorPickerState createState() => ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> {
  ColorPickerState();

  // Color
  late int _alpha;
  late Color _color;
  late HSVColor _hSVColor;

  void _alphaOnChanged(int value) {
    _alpha = value;
    super.widget.onChanged(_color.withAlpha(value));
  }

  void _colorOnChanged(Color value) {
    _color = value;
    _hSVColor = HSVColor.fromColor(value);
    super.widget.onChanged(value);
  }

  void _hSVColorOnChanged(HSVColor value) {
    _color = value.toColor();
    _hSVColor = value;
    super.widget.onChanged(value.toColor());
  }

  void _colorWithAlphaOnChanged(Color value) {
    _alpha = value.alpha;
    final Color color = value.withAlpha(255);
    _color = color;
    _hSVColor = HSVColor.fromColor(color);
    super.widget.onChanged(value);
  }

  // Pickers
  int _index = 4;
  late List<_IPicker> _pickers;
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
        index: 0,
        name: 'Swatches',
        builder: (BuildContext context) => SwatchesPicker(
          onChanged: (Color value) => super.setState(
            () => _colorWithAlphaOnChanged(value),
          ),
        ),
      ),

      // RGBPicker
      _IPicker(
        index: 1,
        name: 'RGB',
        builder: (BuildContext context) => RGBPicker(
          color: _color,
          onChanged: (Color value) => super.setState(
            () => _colorOnChanged(value),
          ),
        ),
      ),

      // HSVPicker
      _IPicker(
        index: 2,
        name: 'HSV',
        builder: (BuildContext context) => HSVPicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // WheelPicker
      _IPicker(
        index: 3,
        name: 'Wheel',
        builder: (BuildContext context) => WheelPicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // PaletteHuePicker
      _IPicker(
        index: 4,
        name: 'Palette Hue',
        builder: (BuildContext context) => PaletteHuePicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // PaletteSaturationPicker
      _IPicker(
        index: 5,
        name: 'Palette Saturation',
        builder: (BuildContext context) => PaletteSaturationPicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),

      // PaletteValuePicker
      _IPicker(
        index: 6,
        name: 'Palette Value',
        builder: (BuildContext context) => PaletteValuePicker(
          color: _hSVColor,
          onChanged: (HSVColor value) => super.setState(
            () => _hSVColorOnChanged(value),
          ),
        ),
      ),
    ];
  }

  // Dropdown
  DropdownMenuItem<_IPicker> _buildDropdownMenuItems(_IPicker item) {
    return DropdownMenuItem<_IPicker>(
      value: item,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0.0),
        child: Text(
          item.name,
          style: _index == item.index
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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildHead(),
                _buildDropdown(),
                _buildAlphaPicker(),
              ],
            ),
            Expanded(
              child: _buildBody(),
            )
          ],
        );
    }
  }
}
