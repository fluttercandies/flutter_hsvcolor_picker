import 'package:flutter/material.dart';

/// Palette for selecting two values between 0 and 1.
class PalettePicker extends StatefulWidget {
  const PalettePicker({
    required this.position,
    required this.onChanged,
    required this.leftRightColors,
    required this.topBottomColors,
    this.leftPosition = 0.0,
    this.rightPosition = 1.0,
    this.topPosition = 0.0,
    this.bottomPosition = 1.0,
    this.border = const Border.fromBorderSide(BorderSide(color: Colors.grey)),
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
    Key? key,
  }) : super(key: key);

  final Border? border;
  final BorderRadius? borderRadius;
  final Offset position;
  final ValueChanged<Offset> onChanged;
  final double leftPosition;
  final double rightPosition;
  final List<Color> leftRightColors;
  final double topPosition;
  final double bottomPosition;
  final List<Color> topBottomColors;

  @override
  State<PalettePicker> createState() => _PalettePickerState();
}

class _PalettePickerState extends State<PalettePicker> {
  final GlobalKey paletteKey = GlobalKey();

  Offset get position => widget.position;
  double get leftPosition => widget.leftPosition;
  double get rightPosition => widget.rightPosition;
  double get topPosition => widget.topPosition;
  double get bottomPosition => widget.bottomPosition;

  /// Position(min, max) > Ratio(0, 1)
  Offset positionToRatio() {
    final double ratioX = leftPosition < rightPosition
        ? positionToRatio2(position.dx, leftPosition, rightPosition)
        : 1.0 - positionToRatio2(position.dx, rightPosition, leftPosition);

    final double ratioY = topPosition < bottomPosition
        ? positionToRatio2(position.dy, topPosition, bottomPosition)
        : 1.0 - positionToRatio2(position.dy, bottomPosition, topPosition);

    return Offset(ratioX, ratioY);
  }

  double positionToRatio2(
    double postiton,
    double minPostition,
    double maxPostition,
  ) {
    if (postiton < minPostition) return 0.0;
    if (postiton > maxPostition) return 1.0;
    return (postiton - minPostition) / (maxPostition - minPostition);
  }

  /// Ratio(0, 1) > Position(min, max)
  void ratioToPosition(Offset ratio) {
    final RenderBox? renderBox =
        paletteKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset startposition =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final Size size = renderBox?.size ?? Size.zero;
    final Offset updateOffset = ratio - startposition;

    final double ratioX = updateOffset.dx / size.width;
    final double ratioY = updateOffset.dy / size.height;

    final double positionX = leftPosition < rightPosition
        ? ratioToPosition2(ratioX, leftPosition, rightPosition)
        : ratioToPosition2(1.0 - ratioX, rightPosition, leftPosition);

    final double positionY = topPosition < bottomPosition
        ? ratioToPosition2(ratioY, topPosition, bottomPosition)
        : ratioToPosition2(1.0 - ratioY, bottomPosition, topPosition);

    final Offset position = Offset(positionX, positionY);
    widget.onChanged(position);
  }

  double ratioToPosition2(
    double ratio,
    double minposition,
    double maxposition,
  ) {
    if (ratio < 0.0) return minposition;
    if (ratio > 1.0) return maxposition;
    return ratio * maxposition + (1.0 - ratio) * minposition;
  }

  Widget buildLeftRightColors() {
    return Container(
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.borderRadius,
        gradient: LinearGradient(
          colors: widget.leftRightColors,
        ),
      ),
    );
  }

  Widget buildTopBottomColors() {
    return Container(
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: widget.topBottomColors,
        ),
      ),
    );
  }

  Widget buildGestureDetector() {
    return GestureDetector(
      onPanStart: (DragStartDetails details) =>
          ratioToPosition(details.globalPosition),
      onPanUpdate: (DragUpdateDetails details) =>
          ratioToPosition(details.globalPosition),
      onPanDown: (DragDownDetails details) =>
          ratioToPosition(details.globalPosition),
      child: SizedBox(
        key: paletteKey,
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: _PalettePainter(
            ratio: positionToRatio(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // LeftRightColors
        buildLeftRightColors(),

        // TopBottomColors
        buildTopBottomColors(),

        // GestureDetector
        buildGestureDetector(),
      ],
    );
  }
}

class _PalettePainter extends CustomPainter {
  _PalettePainter({
    required this.ratio,
  }) : super();

  final Offset ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final Paint paintBlack = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final Offset offset = Offset(size.width * ratio.dx, size.height * ratio.dy);
    canvas.drawCircle(offset, 12, paintBlack);
    canvas.drawCircle(offset, 12, paintWhite);
  }

  @override
  bool shouldRepaint(_PalettePainter other) => true;
}
