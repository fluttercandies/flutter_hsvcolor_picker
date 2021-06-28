import 'package:flutter/material.dart';

/// Slider for selecting a value between 0 and 1
class SliderPicker extends StatefulWidget {
  const SliderPicker({
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.colors,
    this.child,
    Key? key,
  })  : assert(value >= min && value <= max),
        super(key: key);

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final List<Color>? colors;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _SliderPickerState();
}

class _SliderPickerState extends State<SliderPicker> {
  double get value => widget.value;
  double get min => widget.min;
  double get max => widget.max;

  double getRatio() => ((value - min) / (max - min)).clamp(0.0, 1.0);
  void setRatio(double ratio) => widget.onChanged(
        (ratio * (max - min) + min).clamp(min, max),
      );

  void onPanUpdate(DragUpdateDetails details, BoxConstraints box) {
    final RenderBox? renderBox = super.context.findRenderObject() as RenderBox?;
    final Offset offset =
        renderBox?.globalToLocal(details.globalPosition) ?? Offset.zero;
    final double ratio = offset.dx / box.maxWidth;
    super.setState(() => setRatio(ratio));
  }

  BorderRadius radius = const BorderRadius.all(
    Radius.circular(20.0),
  );

  Widget buildSlider(double maxWidth) {
    return SizedBox(
      width: maxWidth,
      child: CustomMultiChildLayout(
        delegate: _SliderLayout(),
        children: <Widget>[
          // Track
          LayoutId(
            id: _SliderLayout.track,
            child: (widget.colors == null)
                ?

                // Child
                DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: radius,
                      child: widget.child,
                    ),
                  )
                :

                // Color
                DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      border: Border.all(color: Colors.grey),
                      gradient: LinearGradient(colors: widget.colors!),
                    ),
                  ),
          ),

          // Thumb
          LayoutId(
            id: _SliderLayout.thumb,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(
                  _ThumbPainter.getWidth(getRatio(), maxWidth),
                ),
              child: CustomPaint(
                painter: _ThumbPainter(),
              ),
            ),
          ),

          // GestureContainer
          LayoutId(
            id: _SliderLayout.gestureContainer,
            child: LayoutBuilder(builder: buildGestureDetector),
          )
        ],
      ),
    );
  }

  Widget buildGestureDetector(BuildContext context, BoxConstraints box) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails detail) => onPanUpdate(detail, box),
      child: Container(
        color: const Color(0x00000000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) =>
            buildSlider(box.maxWidth),
      ),
    );
  }
}

/// Slider
class _SliderLayout extends MultiChildLayoutDelegate {
  static const String track = 'track';
  static const String thumb = 'thumb';
  static const String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    // Track
    super.layoutChild(
      track,
      BoxConstraints.tightFor(
          width: size.width, height: _ThumbPainter.doubleTrackWidth),
    );
    super.positionChild(
      track,
      Offset(0.0, size.height / 2 - _ThumbPainter.trackWidth),
    );

    // Thumb
    super.layoutChild(
      thumb,
      BoxConstraints.tightFor(width: 10.0, height: size.height / 2),
    );
    super.positionChild(
      thumb,
      Offset(0.0, size.height * 0.5),
    );

    // GestureContainer
    super.layoutChild(
      gestureContainer,
      BoxConstraints.tightFor(width: size.width, height: size.height),
    );
    super.positionChild(gestureContainer, Offset.zero);
  }

  @override
  bool shouldRelayout(_SliderLayout oldDelegate) => false;
}

/// Thumb
class _ThumbPainter extends CustomPainter {
  static double width = 12;
  static double trackWidth = 14;
  static double doubleTrackWidth = 28;
  static double getWidth(double value, double maxWidth) =>
      (maxWidth - trackWidth - trackWidth) * value + trackWidth;

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

    canvas.drawCircle(Offset.zero, _ThumbPainter.width, paintBlack);
    canvas.drawCircle(Offset.zero, _ThumbPainter.width, paintWhite);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
