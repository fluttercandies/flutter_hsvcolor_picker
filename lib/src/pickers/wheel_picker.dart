import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Color palette and color wheel.
class WheelPicker extends StatefulWidget {
  const WheelPicker({
    required this.color,
    required this.onChanged,
    this.showPalette = true,
    Key? key,
  }) : super(key: key);

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final bool showPalette;

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  HSVColor get color => widget.color;

  final GlobalKey paletteKey = GlobalKey();
  Offset getOffset(Offset ratio) {
    final RenderBox? renderBox =
        paletteKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset startPosition =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    return ratio - startPosition;
  }

  Size getSize() {
    final RenderBox? renderBox =
        paletteKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }

  bool isWheel = false;
  bool isPalette = false;
  void onPanStart(Offset offset) {
    final RenderBox? renderBox =
        paletteKey.currentContext?.findRenderObject() as RenderBox?;
    final Size size = renderBox?.size ?? Size.zero;

    final double radio = _WheelPainter.radio(size);
    final double squareRadio = _WheelPainter.squareRadio(radio);

    final Offset startPosition =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset vector = offset - startPosition - center;

    final bool isPalette =
        vector.dx.abs() < squareRadio && vector.dy.abs() < squareRadio;
    isWheel = !isPalette;
    this.isPalette = isPalette;

    // isWheel = vector.distance + _WheelPainter.strokeWidth > radio &&
    //     vector.distance - squareRadio < radio;
    // this.isPalette =
    //     vector.dx.abs() < squareRadio && vector.dy.abs() < squareRadio;

    if (isWheel) {
      widget.onChanged(
        color.withHue(
          _Wheel.vectorToHue(vector),
        ),
      );
    }
    if (widget.showPalette && this.isPalette) {
      widget.onChanged(
        HSVColor.fromAHSV(
          color.alpha,
          color.hue,
          _Wheel.vectorToSaturation(vector.dx, squareRadio).clamp(0.0, 1.0),
          _Wheel.vectorToValue(vector.dy, squareRadio).clamp(0.0, 1.0),
        ),
      );
    }
  }

  void onPanUpdate(Offset offset) {
    if (!widget.showPalette && isPalette) return;
    final RenderBox? renderBox =
        paletteKey.currentContext?.findRenderObject() as RenderBox?;
    final Size size = renderBox?.size ?? Size.zero;

    final double radio = _WheelPainter.radio(size);
    final double squareRadio = _WheelPainter.squareRadio(radio);

    final Offset startPosition =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final Offset vector = offset - startPosition - center;

    if (isWheel) {
      widget.onChanged(
        color.withHue(
          _Wheel.vectorToHue(vector),
        ),
      );
    }
    if (isPalette) {
      widget.onChanged(
        HSVColor.fromAHSV(
          color.alpha,
          color.hue,
          _Wheel.vectorToSaturation(vector.dx, squareRadio).clamp(0.0, 1.0),
          _Wheel.vectorToValue(vector.dy, squareRadio).clamp(0.0, 1.0),
        ),
      );
    }
  }

  void onPanDown(Offset offset) => isWheel = isPalette = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        onPanStart(details.globalPosition);
      },
      onPanUpdate: (DragUpdateDetails details) {
        onPanUpdate(details.globalPosition);
      },
      onPanDown: (DragDownDetails details) => onPanDown(details.globalPosition),
      child: Container(
        key: paletteKey,
        padding: const EdgeInsets.only(top: 12.0),
        width: 240,
        height: 240,
        child: CustomPaint(
          painter: _WheelPainter(
            color: color,
            showColorBox: widget.showPalette,
          ),
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  const _WheelPainter({
    required this.color,
    required this.showColorBox,
  }) : super();

  static double strokeWidth = 8;
  static double doubleStrokeWidth = 16;
  static double radio(Size size) =>
      math.min(size.width, size.height).toDouble() / 2 -
      _WheelPainter.strokeWidth;
  static double squareRadio(double radio) =>
      (radio - _WheelPainter.strokeWidth) / 1.414213562373095;

  final HSVColor color;
  final bool showColorBox;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radio = _WheelPainter.radio(size);
    final double squareRadio = _WheelPainter.squareRadio(radio);

    // Wheel
    final Shader sweepShader = const SweepGradient(
      center: Alignment.bottomRight,
      colors: <Color>[
        Color.fromARGB(255, 255, 0, 0),
        Color.fromARGB(255, 255, 255, 0),
        Color.fromARGB(255, 0, 255, 0),
        Color.fromARGB(255, 0, 255, 255),
        Color.fromARGB(255, 0, 0, 255),
        Color.fromARGB(255, 255, 0, 255),
        Color.fromARGB(255, 255, 0, 0),
      ],
    ).createShader(
      Rect.fromLTWH(0, 0, radio, radio),
    );
    canvas.drawCircle(
      center,
      radio,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _WheelPainter.doubleStrokeWidth
        ..shader = sweepShader,
    );

    canvas.drawCircle(
      center,
      radio - _WheelPainter.strokeWidth,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey,
    );
    canvas.drawCircle(
      center,
      radio + _WheelPainter.strokeWidth,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey,
    );

    // Thumb on color wheel
    final Paint paintWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final Paint paintBlack = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    final Offset wheel = _Wheel.hueToVector(
        (color.hue + 360.0) * math.pi / 180.0, radio, center);
    canvas.drawCircle(wheel, 12, paintBlack);
    canvas.drawCircle(wheel, 12, paintWhite);

    if (!showColorBox) return;

    // Palette
    final Rect rect = Rect.fromLTWH(center.dx - squareRadio,
        center.dy - squareRadio, squareRadio * 2, squareRadio * 2);
    final RRect rRect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(4),
    );

    final Shader horizontal = LinearGradient(
      colors: <Color>[
        Colors.white,
        HSVColor.fromAHSV(1.0, color.hue, 1.0, 1.0).toColor()
      ],
    ).createShader(rect);
    canvas.drawRRect(
      rRect,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = horizontal,
    );

    final Shader vertical = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Colors.transparent, Colors.black],
    ).createShader(rect);
    canvas.drawRRect(
      rRect,
      Paint()
        ..style = PaintingStyle.fill
        ..shader = vertical,
    );

    canvas.drawRRect(
      rRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey,
    );

    // Thumb on color box
    final double paletteX =
        _Wheel.saturationToVector(color.saturation, squareRadio, center.dx);
    final double paletteY =
        _Wheel.valueToVector(color.value, squareRadio, center.dy);
    final Offset paletteVector = Offset(paletteX, paletteY);
    canvas.drawCircle(paletteVector, 12, paintBlack);
    canvas.drawCircle(paletteVector, 12, paintWhite);
  }

  @override
  bool shouldRepaint(_WheelPainter other) => true;
}

class _Wheel {
  static double vectorToHue(Offset vector) =>
      (((math.atan2(vector.dy, vector.dx)) * 180.0 / math.pi) + 360.0) % 360.0;
  static double vectorToSaturation(double vectorX, double squareRadio) =>
      vectorX * 0.5 / squareRadio + 0.5;
  static double vectorToValue(double vectorY, double squareRadio) =>
      0.5 - vectorY * 0.5 / squareRadio;

  static Offset hueToVector(double h, double radio, Offset center) =>
      Offset(math.cos(h) * radio + center.dx, math.sin(h) * radio + center.dy);
  static double saturationToVector(
          double s, double squareRadio, double centerX) =>
      (s - 0.5) * squareRadio / 0.5 + centerX;
  static double valueToVector(double l, double squareRadio, double centerY) =>
      (0.5 - l) * squareRadio / 0.5 + centerY;
}
