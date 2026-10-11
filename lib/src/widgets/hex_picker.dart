import 'package:flutter/material.dart';

import '../color_channels.dart';

/// Textfield for entering the Hex color code (RRGGBB).
class HexPicker extends StatefulWidget {
  const HexPicker({
    required this.color,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  State<HexPicker> createState() => _HexPickerState();
}

class _HexPickerState extends State<HexPicker> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _Hex.colorToString(widget.color).toUpperCase(),
    );
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant HexPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isRgbChanged = _Hex.colorToString(oldWidget.color) != _Hex.colorToString(widget.color);

    if (isRgbChanged) {
      final text = _Hex.colorToString(widget.color).toUpperCase();
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void textOnSubmitted(String value) => widget.onChanged(
        textOnChenged(value),
      );
  Color textOnChenged(String text) {
    final String? hex = _Hex.textSubString(text);
    if (hex == null) return widget.color;

    return _Hex.intToColor(_Hex.stringToInt(hex));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '#',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
        ),

        // TextField
        Expanded(
          child: TextField(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20),
            focusNode: _focusNode,
            controller: _controller,
            onSubmitted: textOnSubmitted,
            decoration: const InputDecoration.collapsed(hintText: 'hex code'),
          ),
        )
      ],
    );
  }
}

class _Hex {
  // Hex Number To Color
  static Color intToColor(int hexNumber) => Color.fromARGB(
        255,
        (hexNumber >> 16) & 0xFF,
        (hexNumber >> 8) & 0xFF,
        (hexNumber >> 0) & 0xFF,
      );

  // String To Hex Number
  static int stringToInt(String hex) => int.parse(hex, radix: 16);

  // String To Color
  static String colorToString(Color color) =>
      _colorToString(
        color.red8.toRadixString(16),
      ) +
      _colorToString(
        color.green8.toRadixString(16),
      ) +
      _colorToString(
        color.blue8.toRadixString(16),
      );
  static String _colorToString(String text) => text.length == 1 ? '0$text' : text;

  // Accept RGB hex values with optional # or 0x prefixes.
  static String? textSubString(String? text) {
    if (text == null) return null;
    return RegExp(r'^(?:#|0[xX])?([0-9a-fA-F]{6})$').firstMatch(text.trim())?.group(1);
  }
}
