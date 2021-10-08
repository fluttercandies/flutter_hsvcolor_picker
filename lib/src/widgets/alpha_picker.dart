import 'package:flutter/material.dart';

import 'slider_picker.dart';
import 'slider_title.dart';

/// Slider for selecting the alpha value (0-255).
class AlphaPicker extends StatefulWidget {
  const AlphaPicker({
    required this.alpha,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final int alpha;
  final ValueChanged<int> onChanged;

  @override
  State<StatefulWidget> createState() => _AlphaPickerState();
}

class _AlphaPickerState extends State<AlphaPicker> {
  void valueOnChanged(double ratio) {
    widget.onChanged(ratio.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Alpha
        SliderTitle('A', widget.alpha.toString()),
        SliderPicker(
          value: widget.alpha.toDouble(),
          max: 255.0,
          onChanged: valueOnChanged,
          child: CustomPaint(
            painter: _AlphaTrackPainter(),
          ),
        )
      ],
    );
  }
}

// Track
class _AlphaTrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double side = size.height / 2;
    final Paint paint = Paint()..color = Colors.black12;

    for (int i = 0; i * side < size.width; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromLTWH(i * side, 0, side, side), paint);
      } else {
        canvas.drawRect(Rect.fromLTWH(i * side, side, side, side), paint);
      }
    }

    final Rect rect = Offset.zero & size;
    const Gradient gradient = LinearGradient(
      colors: <Color>[Colors.transparent, Colors.grey],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
