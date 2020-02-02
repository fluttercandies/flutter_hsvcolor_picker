/// HSV color picker
///
/// [SliderPicker]
/// [PalettePicker]
///
/// [RGBPicker]
/// [HSVPicker]
/// [WheelPicker]
///
/// [PaletteHuePicker]
/// [PaletteSaturationPicker]
/// [PaletteValuePicker]
///
/// [HexPicker]
/// [AlphaPicker]
/// [SwatchesPicker]
///
/// [ColorPicker]
///

library flutter_hsvcolor_picker;

import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/painting.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "dart:math" as Math;



//---------------------------SliderPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";


class SliderPicker extends StatefulWidget {

  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final List<Color> colors;
  final Widget child;

  const SliderPicker({
    Key key,
    this.min = 0.0,
    this.max = 1.0,
    @required this.value,
    @required this.onChanged,
    this.colors,
    this.child,
  }) : assert(value != null),
        assert(value >= min && value <= max),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SliderPickerState();
}

class _SliderPickerState extends State<SliderPicker> {

  double get value=> super.widget.value;
  double get min=> super.widget.min;
  double get max=> super.widget.max;

  double getRatio() => ((value - min) / (max - min)).clamp(0.0, 1.0);
  void setRatio(double ratio) => super.widget.onChanged((ratio * (max - min) + min).clamp(min, max));

  void onPanUpdate (DragUpdateDetails details, BoxConstraints box) {
    RenderBox renderBox = super.context.findRenderObject();
    Offset offset = renderBox.globalToLocal(details.globalPosition);
    double ratio=offset.dx/box.maxWidth;
    super.setState(() =>this.setRatio(ratio));
  }


  BorderRadius radius = const BorderRadius.all(const Radius.circular(20.0));

  Widget buildSlider(double maxWidth) {
    return new Container(
        width: maxWidth,
        child: new CustomMultiChildLayout(
            delegate: new _SliderLayout(),
            children: <Widget>[

              //Track
              new LayoutId(
                  id: _SliderLayout.track,
                  child: (super.widget.colors==null)?

                  //child
                  new DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: this.radius,
                          border: new Border.all(color: Colors.grey, width: 1)
                      ),
                      child: new ClipRRect(
                          borderRadius: this.radius,
                          child: super.widget.child
                      )
                  ):

                  //Color
                  new DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: this.radius,
                          border: new Border.all(color: Colors.grey, width: 1),
                          gradient: new LinearGradient(
                              colors: super.widget.colors
                          )
                      )
                  )

              ),

              //Thumb
              new LayoutId(
                  id: _SliderLayout.thumb,
                  child: new Transform(
                    transform: new Matrix4.identity()..translate(
                        _ThumbPainter.getWidth(this.getRatio(), maxWidth)
                    ),
                    child: new CustomPaint(painter: new _ThumbPainter()),
                  )
              ),

              //GestureContainer
              new LayoutId(
                  id: _SliderLayout.gestureContainer,
                  child: new LayoutBuilder(
                      builder: this.buildGestureDetector
                  )
              )

            ]
        )
    );
  }

  Widget buildGestureDetector(BuildContext context, BoxConstraints box){
    return new GestureDetector(
        child: new Container(color: const Color(0)),
        onPanUpdate: (detail) => this.onPanUpdate(detail, box)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
        height: 40.0,
        child: new LayoutBuilder(
            builder: (context, box) => this.buildSlider(box.maxWidth)
        )
    );
  }
}


/// Slider
class _SliderLayout extends MultiChildLayoutDelegate {

  static final String track = "track";
  static final String thumb = "thumb";
  static final String gestureContainer = "gesturecontainer";


  @override
  void performLayout(Size size) {

    //Track
    super.layoutChild(track, BoxConstraints.tightFor(width: size.width, height: _ThumbPainter.doubleTrackWidth));
    super.positionChild(track, Offset(0.0, size.height / 2 - _ThumbPainter.trackWidth));

    //Thumb
    super.layoutChild(thumb, BoxConstraints.tightFor(width: 10.0, height: size.height / 2));
    super.positionChild(thumb, Offset(0.0, size.height * 0.5));

    //GestureContainer
    super.layoutChild(gestureContainer, BoxConstraints.tightFor(width: size.width, height: size.height));
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
      (maxWidth - trackWidth- trackWidth) * value + trackWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintWhite = new Paint()..color=Colors.white..strokeWidth=4..style=PaintingStyle.stroke;
    final Paint paintBlack = new Paint()..color=Colors.black..strokeWidth=6..style=PaintingStyle.stroke;

    canvas.drawCircle(Offset.zero, _ThumbPainter.width, paintBlack);
    canvas.drawCircle(Offset.zero, _ThumbPainter.width, paintWhite);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


//
//
//---------------------------SliderPicker.dart-------------------------------










//---------------------------PalettePicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "package:flutter/foundation.dart";
//import "package:flutter/gestures.dart";
//import "package:flutter/rendering.dart";
//import "package:flutter/widgets.dart";
//import "package:flutter/cupertino.dart";
//import "package:flutter/painting.dart";


class PalettePicker extends StatefulWidget {

  final Offset position;
  final ValueChanged<Offset> onChanged;

  final double leftPosition;
  final double rightPosition;
  final List<Color> leftRightColors;

  final double topPosition;
  final double bottomPosition;
  final List<Color> topBottomColors;


  PalettePicker({
    Key key,
    @required this.position,
    @required this.onChanged,

    this.leftPosition=0.0,
    this.rightPosition=1.0,
    @required this.leftRightColors,

    this.topPosition=0.0,
    this.bottomPosition=1.0,
    @required this.topBottomColors
  }) : assert(position != null),
        super(key: key);

  @override
  _PalettePickerState createState() => new _PalettePickerState();
}

class _PalettePickerState extends State<PalettePicker> {

  final GlobalKey paletteKey = GlobalKey();

  Offset get position=> super.widget.position;
  double get leftPosition=> super.widget.leftPosition;
  double get rightPosition=> super.widget.rightPosition;
  double get topPosition=> super.widget.topPosition;
  double get bottomPosition=> super.widget.bottomPosition;


  /// Position(min, max) > Ratio(0, 1)
  Offset positionToRatio(){
    double ratioX = this.leftPosition < this.rightPosition?
    this.positionToRatio2(this.position.dx, this.leftPosition, this.rightPosition):
    1.0 - this.positionToRatio2(this.position.dx, this.rightPosition, this.leftPosition);

    double ratioY = this.topPosition < this.bottomPosition?
    this.positionToRatio2(this.position.dy, this.topPosition, this.bottomPosition):
    1.0 - this.positionToRatio2(this.position.dy, this.bottomPosition, this.topPosition);

    return new Offset(ratioX, ratioY);
  }
  double positionToRatio2(double postiton, double minPostition, double maxPostition){
    if(postiton < minPostition) return 0.0;
    if(postiton > maxPostition) return 1.0;
    return (postiton - minPostition) / (maxPostition - minPostition);
  }

  /// Ratio(0, 1) > Position(min, max)
  void ratioToPosition(Offset ratio){
    RenderBox renderBox = this.paletteKey.currentContext.findRenderObject();
    Offset startposition = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;
    Offset updateOffset= ratio-startposition;

    double ratioX = updateOffset.dx / size.width;
    double ratioY = updateOffset.dy / size.height;

    double positionX = this.leftPosition < this.rightPosition?
    this.ratioToPosition2(ratioX, this.leftPosition, this.rightPosition):
    this.ratioToPosition2(1.0 - ratioX, this.rightPosition, this.leftPosition);

    double positionY= this.topPosition < this.bottomPosition?
    this.ratioToPosition2(ratioY, this.topPosition, this.bottomPosition):
    this.ratioToPosition2(1.0 - ratioY, this.bottomPosition, this.topPosition);

    Offset position = new Offset(positionX, positionY);
    super.widget.onChanged(position);
  }
  double ratioToPosition2(double ratio, double minposition, double maxposition){
    if(ratio < 0.0) return minposition;
    if(ratio > 1.0) return maxposition;
    return  ratio * maxposition + (1.0 - ratio) * minposition;
  }


  Widget buildLeftRightColors() {
    return new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1),
            borderRadius: const BorderRadius.all(const Radius.circular(6)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: super.widget.leftRightColors
            )
        )
    );
  }

  Widget buildTopBottomColors() {
    return new Container(
        decoration: new BoxDecoration(
            border: new Border.all(color: Colors.grey, width: 1),
            borderRadius: const BorderRadius.all(const Radius.circular(6)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: super.widget.topBottomColors
            )
        )
    );
  }

  Widget buildGestureDetector() {
    return new GestureDetector(
        onPanStart: (details)=>this.ratioToPosition(details.globalPosition),
        onPanUpdate: (details)=>this.ratioToPosition(details.globalPosition),
        onPanDown: (details)=>this.ratioToPosition(details.globalPosition),
        child: new SizedBox(
            key: this.paletteKey,
            width: double.infinity,
            height: double.infinity,
            child: new CustomPaint(
                painter: new _PalettePainter(ratio: this.positionToRatio())
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
        children: <Widget>[

          //LeftRightColors
          this.buildLeftRightColors(),

          //TopBottomColors
          this.buildTopBottomColors(),

          //GestureDetector
          this.buildGestureDetector(),

        ]
    );
  }
}


class _PalettePainter extends CustomPainter{

  final Offset ratio;
  _PalettePainter({Key key, this.ratio}):super();

  @override
  void paint(Canvas canvas, Size size) {

    final Paint paintWhite = new Paint()..color=Colors.white..strokeWidth=4..style=PaintingStyle.stroke;
    final Paint paintBlack = new Paint()..color=Colors.black..strokeWidth=6..style=PaintingStyle.stroke;

    Offset offset=new Offset(size.width * this.ratio.dx, size.height * this.ratio.dy);
    canvas.drawCircle(offset, 12, paintBlack);
    canvas.drawCircle(offset, 12, paintWhite);
  }

  @override
  bool shouldRepaint(_PalettePainter other) => true;
}



//
//
//---------------------------PalettePicker.dart-------------------------------










//---------------------------RGBPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "SliderPicker.dart";

class RGBPicker extends StatefulWidget {

  final Color color;
  final ValueChanged<Color> onChanged;

  RGBPicker({
    Key key,
    this.color,
    @required this.onChanged
  }) : assert(color != null),
        super(key: key);

  @override
  _RGBPickerState createState() => new _RGBPickerState();
}

class _RGBPickerState extends State<RGBPicker> {

  Color get color=> super.widget.color;

  //Red
  void redOnChange(double value) => super.widget.onChanged(Color.fromARGB(this.color.alpha, value.toInt(), this.color.green, this.color.blue));
  List<Color> get redColors =>[
    this.color.withRed(0),
    this.color.withRed(255)
  ];

  //Green
  void greenOnChange(double value) => super.widget.onChanged(Color.fromARGB(this.color.alpha, this.color.red, value.toInt(), this.color.blue));
  List<Color> get greenColors =>[
    this.color.withGreen(0),
    this.color.withGreen(255)
  ];

  //Blue
  void blueOnChange(double value) => super.widget.onChanged(Color.fromARGB(this.color.alpha, this.color.red, this.color.green, value.toInt()));
  List<Color> get blueColors =>[
    this.color.withBlue(0),
    this.color.withBlue(255)
  ];


  Widget buildTitle(String title, String text){
    return new SizedBox(
        height: 34.0,
        child: new Row(
            children: <Widget>[
              new Opacity(
                  opacity: 0.5,
                  child: new Text(
                      title,
                      style: Theme.of(context).textTheme.title.copyWith(fontSize: 18)
                  )
              ),
              new Expanded(
                  child: new Align(
                      alignment: Alignment.centerRight,
                      child: new Text(
                          text,
                          style: Theme.of(context).textTheme.headline.copyWith(fontSize: 18)
                      )
                  )
              )
            ]
        )
    );
  }


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Red
          this.buildTitle("R", this.color.red.toInt().toString()),
          new SliderPicker(
            value: this.color.red.toDouble(),
            min: 0.0,
            max: 255.0,
            onChanged: this.redOnChange,
            colors: this.redColors,
          ),

          //Green
          this.buildTitle("G", this.color.green.toInt().toString()),
          new SliderPicker(
              value: this.color.green.toDouble(),
              min: 0.0,
              max: 255.0,
              onChanged: this.greenOnChange,
              colors: this.greenColors
          ),

          //Blue
          this.buildTitle("B", this.color.blue.toInt().toString()),
          new SliderPicker(
              value: this.color.blue.toDouble(),
              min: 0.0,
              max: 255.0,
              onChanged: this.blueOnChange,
              colors: this.blueColors
          )

        ]
    );
  }
}


//
//
//---------------------------RGBPicker.dart-------------------------------










//---------------------------HSVPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "SliderPicker.dart";

class HSVPicker extends StatefulWidget {

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;

  HSVPicker({
    Key key,
    @required this.color,
    @required this.onChanged
  }) : assert(color != null),
        super(key: key);

  @override
  _HSVPickerState createState() => new _HSVPickerState();
}

class _HSVPickerState extends State<HSVPicker> {

  HSVColor get color=> super.widget.color;

  //Hue
  void hueOnChange(double value) => super.widget.onChanged(this.color.withHue(value));
  List<Color> get hueColors =>[
    this.color.withHue(0.0).toColor(),
    this.color.withHue(60.0).toColor(),
    this.color.withHue(120.0).toColor(),
    this.color.withHue(180.0).toColor(),
    this.color.withHue(240.0).toColor(),
    this.color.withHue(300.0).toColor(),
    this.color.withHue(0.0).toColor()
  ];

  //Saturation
  void saturationOnChange(double value) => super.widget.onChanged(this.color.withSaturation(value));
  List<Color> get saturationColors =>[
    this.color.withSaturation(0.0).toColor(),
    this.color.withSaturation(1.0).toColor()
  ];

  //Value
  void valueOnChange(double value) => super.widget.onChanged(this.color.withValue(value));
  List<Color> get valueColors =>[
    this.color.withValue(0.0).toColor(),
    this.color.withValue(1.0).toColor()
  ];


  Widget buildTitle(String title, String text){
    return new SizedBox(
        height: 34.0,
        child: new Row(
            children: <Widget>[
              new Opacity(
                  opacity: 0.5,
                  child: new Text(
                      title,
                      style: Theme.of(context).textTheme.title
                  )
              ),
              new Expanded(
                  child: new Align(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        text,
                        style: Theme.of(context).textTheme.headline.copyWith(fontSize: 18),
                      )
                  )
              )
            ]
        )
    );
  }


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Hue
          this.buildTitle("H", this.color.hue.toInt().toString()+"º"),
          new SliderPicker(
              value: this.color.hue,
              min: 0.0,
              max: 360.0,
              onChanged: this.hueOnChange,
              colors: this.hueColors
          ),

          //Saturation
          this.buildTitle("S", (this.color.saturation * 100).toInt().toString()+"º"),
          new SliderPicker(
              value: this.color.saturation,
              min: 0.0,
              max: 1.0,
              onChanged: this.saturationOnChange,
              colors: this.saturationColors
          ),

          //Value
          this.buildTitle("L", (this.color.value * 100).toInt().toString()+"º"),
          new SliderPicker(
              value: this.color.value,
              min: 0.0,
              max: 1.0,
              onChanged: this.valueOnChange,
              colors: this.valueColors
          )

        ]
    );
  }
}


//
//
//---------------------------HSVPicker.dart-------------------------------










//---------------------------WheelPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "package:flutter/cupertino.dart";
//import "dart:math" as Math;


class Wheel{
  static double vectorToHue(Offset vector) => (((Math.atan2(vector.dy, vector.dx)) * 180.0 / Math.pi) + 360.0) % 360.0;
  static double vectorToSaturation(double vectorX, double squareRadio) => vectorX * 0.5 / squareRadio + 0.5;
  static double vectorToValue(double vectorY, double squareRadio) => 0.5 - vectorY * 0.5 / squareRadio;

  static Offset hueToVector(double h, double radio, Offset center) => new Offset(Math.cos(h) * radio + center.dx, Math.sin(h) * radio + center.dy);
  static double saturationToVector(double s, double squareRadio, double centerX) => (s - 0.5) * squareRadio / 0.5 + centerX;
  static double valueToVector(double l, double squareRadio, double centerY) => (0.5 - l) * squareRadio / 0.5 + centerY;
}

class WheelPicker extends StatefulWidget {

  final HSVColor color;
  final ValueChanged<HSVColor> onChanged;
  final bool hasPalette;

  WheelPicker({
    Key key,
    @required this.color,
    @required this.onChanged,
    this.hasPalette = true
  }) : assert(color != null),
        super(key: key);

  @override
  _WheelPickerState createState() => new _WheelPickerState();
}

class CustomPanGestureRecognizer extends OneSequenceGestureRecognizer {
  final Function onPanDown;
  final Function onPanUpdate;
  final Function onPanEnd;

  CustomPanGestureRecognizer(
      {@required this.onPanDown,
        @required this.onPanUpdate,
        @required this.onPanEnd});

  @override
  void addPointer(PointerEvent event) {
    if (onPanDown(event.position)) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      onPanUpdate(event.position);
    }
    if (event is PointerUpEvent) {
      onPanEnd(event.position);
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}

class _WheelPickerState extends State<WheelPicker> {

  HSVColor get color=> super.widget.color;
  bool get hasPalette => super.widget.hasPalette;


  final GlobalKey paletteKey = GlobalKey();
  Offset getOffset(Offset ratio){
    RenderBox renderBox = this.paletteKey.currentContext.findRenderObject();
    Offset startPosition = renderBox.localToGlobal(Offset.zero);
    return ratio-startPosition;
  }
  Size getSize(){
    RenderBox renderBox = this.paletteKey.currentContext.findRenderObject();
    return renderBox.size;
  }



  bool isWheel = false;
  bool isPalette = false;
  bool onPanStart(Offset offset){
    RenderBox renderBox = this.paletteKey.currentContext.findRenderObject();
    Size size = renderBox.size;

    double radio =_WheelPainter.radio(size);
    double squareRadio =_WheelPainter.squareRadio(radio);

    Offset startPosition = renderBox.localToGlobal(Offset.zero);
    Offset center = Offset(size.width/2, size.height/2);
    Offset vector = offset-startPosition-center;

    bool isPalette=vector.dx.abs() < squareRadio && vector.dy.abs() < squareRadio;
    this.isWheel = !isPalette;
    this.isPalette = isPalette;

    //this.isWheel = vector.distance + _WheelPainter.strokeWidth > radio && vector.distance - squareRadio < radio;
    //this.isPalette =vector.dx.abs() < squareRadio && vector.dy.abs() < squareRadio;

    if (this.isWheel) {
      super.widget.onChanged(this.color.withHue(Wheel.vectorToHue(vector)));
      return true;
    }
    if (this.isPalette && this.hasPalette) {
      super.widget.onChanged(HSVColor.fromAHSV(
        this.color.alpha,
        this.color.hue,
        Wheel.vectorToSaturation(vector.dx, squareRadio).clamp(0.0, 1.0),
        Wheel.vectorToValue(vector.dy, squareRadio).clamp(0.0, 1.0)
      ));
      return true;
    }
  }

  bool onPanUpdate(Offset offset){
    RenderBox renderBox = this.paletteKey.currentContext.findRenderObject();
    Size size = renderBox.size;

    double radio =_WheelPainter.radio(size);
    double squareRadio =_WheelPainter.squareRadio(radio);

    Offset startPosition = renderBox.localToGlobal(Offset.zero);
    Offset center = Offset(size.width/2, size.height/2);
    Offset vector = offset-startPosition-center;

    if (this.isWheel) super.widget.onChanged(this.color.withHue(Wheel.vectorToHue(vector)));
    if (this.isPalette && this.hasPalette) super.widget.onChanged(HSVColor.fromAHSV(
        this.color.alpha,
        this.color.hue,
        Wheel.vectorToSaturation(vector.dx, squareRadio).clamp(0.0, 1.0),
        Wheel.vectorToValue(vector.dy, squareRadio).clamp(0.0, 1.0)
    ));
    return true;
  }

  bool onPanDown(Offset offset) {
    this.isWheel = this.isPalette = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        CustomPanGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<CustomPanGestureRecognizer>(
                () => CustomPanGestureRecognizer(
                  onPanDown: (details) => this.onPanStart(details),
                  onPanUpdate: (details)=>this.onPanUpdate(details),
                  onPanEnd: (details)=>this.onPanDown(details)),
                  (CustomPanGestureRecognizer instance) {},
          )
      },
      child: new Container(
          key: this.paletteKey,
          padding: const EdgeInsets.only(top: 12.0),
          width: 240,
          height: 240,
          child: new CustomPaint(
              painter: new _WheelPainter(color: this.color, hasPalette: this.hasPalette)
          )
      ),
    );

    return new GestureDetector(
        onPanStart: (details)=>this.onPanStart(details.globalPosition),
        onPanUpdate: (details)=>this.onPanUpdate(details.globalPosition),
        onPanDown: (details)=>this.onPanDown(details.globalPosition),
        child: new Container(
            key: this.paletteKey,
            padding: const EdgeInsets.only(top: 12.0),
            width: 240,
            height: 240,
            child: new CustomPaint(
                painter: new _WheelPainter(color: this.color, hasPalette: this.hasPalette)
            )
        )
    );
  }
}


class _WheelPainter extends CustomPainter{
  static double strokeWidth = 8;
  static double doubleStrokeWidth = 16;
  static double radio(Size size)=> Math.min(size.width, size.height).toDouble() / 2 - _WheelPainter.strokeWidth;
  static double squareRadio(double radio) => (radio - _WheelPainter.strokeWidth)/ 1.414213562373095;

  final HSVColor color;
  final bool hasPalette;

  _WheelPainter({
    Key key,
    this.color,
    this.hasPalette,
  }): super();

  @override
  void paint(Canvas canvas, Size size) {

    Offset center = new Offset(size.width/2, size.height/2);
    double radio =_WheelPainter.radio(size);
    double squareRadio =_WheelPainter.squareRadio(radio);


    //Wheel
    Shader sweepShader = const SweepGradient(
      center: Alignment.bottomRight, 
      colors: const [
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 255, 255, 0),
      Color.fromARGB(255, 0, 255, 0),
      Color.fromARGB(255, 0, 255, 255),
      Color.fromARGB(255, 0, 0, 255),
      Color.fromARGB(255, 255, 0, 255),
      Color.fromARGB(255, 255, 0, 0),
    ]).createShader(Rect.fromLTWH(0, 0, radio, radio));
    canvas.drawCircle(center, radio, new Paint()..style=PaintingStyle.stroke..strokeWidth = _WheelPainter.doubleStrokeWidth..shader=sweepShader);
    
    canvas.drawCircle(center, radio - _WheelPainter.strokeWidth, new Paint()..style=PaintingStyle.stroke..color=Colors.grey);
    canvas.drawCircle(center, radio + _WheelPainter.strokeWidth, new Paint()..style=PaintingStyle.stroke..color=Colors.grey);


    //Palette
    if (hasPalette) {
      Rect rect = Rect.fromLTWH(
          center.dx - squareRadio, center.dy - squareRadio, squareRadio * 2,
          squareRadio * 2);
      RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(4));

      Shader horizontal = new LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white,
          HSVColor.fromAHSV(1.0, this.color.hue, 1.0, 1.0).toColor()
        ],
      ).createShader(rect);
      canvas.drawRRect(rRect, new Paint()
        ..style = PaintingStyle.fill
        ..shader = horizontal);

      Shader vertical = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black],
      ).createShader(rect);
      canvas.drawRRect(rRect, new Paint()
        ..style = PaintingStyle.fill
        ..shader = vertical);

      canvas.drawRRect(rRect, new Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.grey);
    }

    //Thumb
    final Paint paintWhite = new Paint()..color=Colors.white..strokeWidth=4..style=PaintingStyle.stroke;
    final Paint paintBlack = new Paint()..color=Colors.black..strokeWidth=6..style=PaintingStyle.stroke;
    Offset wheel = Wheel.hueToVector(((this.color.hue + 360.0) * Math.pi / 180.0), radio, center);
    canvas.drawCircle(wheel, 12, paintBlack);
    canvas.drawCircle(wheel, 12, paintWhite);


    //Thumb
    if (hasPalette) {
      double paletteX = Wheel.saturationToVector(
          this.color.saturation, squareRadio, center.dx);
      double paletteY = Wheel.valueToVector(
          this.color.value, squareRadio, center.dy);
      Offset paletteVector = new Offset(paletteX, paletteY);
      canvas.drawCircle(paletteVector, 12, paintBlack);
      canvas.drawCircle(paletteVector, 12, paintWhite);
    }
  }

  @override
  bool shouldRepaint(_WheelPainter other) => true;
}




//
//
//---------------------------WheelPicker.dart-------------------------------










//---------------------------PaletteHuePicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "package:flutter/foundation.dart";
//import "package:flutter/gestures.dart";
//import "package:flutter/rendering.dart";
//import "package:flutter/widgets.dart";
//import "package:flutter/cupertino.dart";
//import "package:flutter/painting.dart";
//import "PalettePicker.dart";
//import "SliderPicker.dart";

class PaletteHuePicker extends StatefulWidget {

  final HSVColor color ;
  final ValueChanged<HSVColor> onChanged;

  PaletteHuePicker({
    Key key,
    @required this.color,
    @required this.onChanged
  }) : assert(color != null),
        super(key: key);

  @override
  _PaletteHuePickerState createState() => new _PaletteHuePickerState();
}


class _PaletteHuePickerState extends State<PaletteHuePicker> {

  HSVColor get color=> super.widget.color;

  //Hue
  void hueOnChange(double value) => super.widget.onChanged(this.color.withHue(value));
  List<Color> get hueColors =>[
    this.color.withHue(0.0).toColor(),
    this.color.withHue(60.0).toColor(),
    this.color.withHue(120.0).toColor(),
    this.color.withHue(180.0).toColor(),
    this.color.withHue(240.0).toColor(),
    this.color.withHue(300.0).toColor(),
    this.color.withHue(0.0).toColor()
  ];

  //Saturation Value
  void saturationValueOnChange(Offset value) => super.widget.onChanged(HSVColor.fromAHSV(this.color.alpha, this.color.hue, value.dx, value.dy));
  //Saturation
  List<Color> get saturationColors =>[
    Colors.white,
    HSVColor.fromAHSV(1.0, this.color.hue, 1.0, 1.0).toColor()
  ];
  //Value
  final List<Color> valueColors =[
    Colors.transparent,
    Colors.black
  ];


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Palette
          new SizedBox(
              height: 280.0,
              child: new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: new PalettePicker(
                      position: new Offset(this.color.saturation, this.color.value),
                      onChanged: this.saturationValueOnChange,
                      leftRightColors: this.saturationColors,
                      topPosition: 1.0,
                      bottomPosition: 0.0,
                      topBottomColors: this.valueColors
                  )
              )
          ),

          //Slider
          new SliderPicker(
              min: 0.0,
              max: 360.0,
              value: this.color.hue,
              onChanged: this.hueOnChange,
              colors: this.hueColors
          )

        ]
    );
  }
}


//
//
//---------------------------PaletteHuePicker.dart-------------------------------










//---------------------------PaletteSaturationPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "package:flutter/foundation.dart";
//import "package:flutter/gestures.dart";
//import "package:flutter/rendering.dart";
//import "package:flutter/widgets.dart";
//import "package:flutter/cupertino.dart";
//import "package:flutter/painting.dart";
//import "PalettePicker.dart";
//import "SliderPicker.dart";

class PaletteSaturationPicker extends StatefulWidget {

  final HSVColor color ;
  final ValueChanged<HSVColor> onChanged;

  PaletteSaturationPicker({
    Key key,
    @required this.color,
    @required this.onChanged
  }) : assert(color != null),
        super(key: key);

  @override
  _PaletteSaturationPickerState createState() => new _PaletteSaturationPickerState();
}


class _PaletteSaturationPickerState extends State<PaletteSaturationPicker> {

  HSVColor get color=> super.widget.color;

  //Saturation
  void saturationOnChange(double value) => super.widget.onChanged(this.color.withSaturation(value));
  List<Color> get saturationColors =>[
    this.color.withSaturation(0.0).toColor(),
    this.color.withSaturation(1.0).toColor()
  ];

  //Hue Value
  Offset get hueValueOffset => new Offset(this.color.hue, this.color.value);
  void hueValueOnChange(Offset value) => super.widget.onChanged(HSVColor.fromAHSV(this.color.alpha, value.dx, this.color.saturation, value.dy));
  //Hue
  final List<Color> hueColors =[
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255),
    const Color.fromARGB(255, 255, 0, 0)
  ];
  //Value
  final List<Color> valueColors =[
    Colors.transparent,
    Colors.black
  ];


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Palette
          new SizedBox(
              height: 280.0,
              child: new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: new PalettePicker(
                      position: this.hueValueOffset,
                      onChanged: this.hueValueOnChange,
                      leftPosition: 0.0,
                      rightPosition: 360.0,
                      leftRightColors: this.hueColors,
                      topPosition: 1.0,
                      bottomPosition: 0.0,
                      topBottomColors: this.valueColors
                  )
              )
          ),

          //Slider
          new SliderPicker(
              min: 0.0,
              max: 1.0,
              value: this.color.saturation,
              onChanged: this.saturationOnChange,
              colors: this.saturationColors
          )

        ]
    );
  }
}


//
//
//---------------------------PaletteSaturationPicker.dart-------------------------------










//---------------------------PaletteValuePicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "package:flutter/foundation.dart";
//import "package:flutter/gestures.dart";
//import "package:flutter/rendering.dart";
//import "package:flutter/widgets.dart";
//import "package:flutter/cupertino.dart";
//import "package:flutter/painting.dart";
//import "PalettePicker.dart";
//import "SliderPicker.dart";

class PaletteValuePicker extends StatefulWidget {

  final HSVColor color ;
  final ValueChanged<HSVColor> onChanged;

  PaletteValuePicker({
    Key key,
    @required this.color,
    @required this.onChanged
  }) : assert(color != null),
        super(key: key);

  @override
  _PaletteValuePickerState createState() => new _PaletteValuePickerState();
}


class _PaletteValuePickerState extends State<PaletteValuePicker> {

  HSVColor get color=> super.widget.color;

  //Value
  void valueOnChange(double value) => super.widget.onChanged(this.color.withValue(value));
  List<Color> get valueColors =>[
    Colors.black,
    this.color.withValue(1.0).toColor()
  ];

  //Hue Saturation
  void hueSaturationOnChange(Offset value) => super.widget.onChanged(HSVColor.fromAHSV(this.color.alpha, value.dx, value.dy, this.color.value));
  //Hue
  final List<Color> hueColors =[
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 255, 255, 0),
    const Color.fromARGB(255, 0, 255, 0),
    const Color.fromARGB(255, 0, 255, 255),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 255, 0, 255),
    const Color.fromARGB(255, 255, 0, 0)
  ];
  //Saturation
  final List<Color> saturationColors =[
    Colors.transparent,
    Colors.white
  ];


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Palette
          new SizedBox(
              height: 280.0,
              child: new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: new PalettePicker(
                      position: new Offset(this.color.hue, this.color.saturation),
                      onChanged: this.hueSaturationOnChange,
                      leftPosition: 0.0,
                      rightPosition: 360.0,
                      leftRightColors: this.hueColors,
                      topPosition: 1.0,
                      bottomPosition: 0.0,
                      topBottomColors: this.saturationColors
                  )
              )
          ),

          //Slider
          new SliderPicker(
              min: 0.0,
              max: 1.0,
              value: this.color.value,
              onChanged: this.valueOnChange,
              colors: this.valueColors
          )

        ]
    );
  }
}

//
//
//---------------------------PaletteValuePicker.dart-------------------------------










//---------------------------HexPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";


class Hex{
  //Hex Number To Color
  static Color intToColor(int hexNumber) => Color.fromARGB(255, (hexNumber >> 16) & 0xFF, ((hexNumber >> 8) & 0xFF), (hexNumber >> 0) & 0xFF);

  //String To Hex Number
  static int stringToInt(String hex) => int.parse(hex, radix:16);

  //String To Color
  static String colorToString(Color color) => _colorToString(color.red.toRadixString(16)) + _colorToString(color.green.toRadixString(16)) + _colorToString(color.blue.toRadixString(16));
  static String _colorToString(String text) => text.length==1?  "0"+text: text;

  //Subste
  static String textSubString(String text){
    if (text == null) return null;

    if (text.length < 6) return null;

    if (text.length == 6) return text;

    return text.substring(text.length - 6, 6);
  }
}

class HexPicker extends StatefulWidget {

  final Color color;
  final ValueChanged<Color> onChanged;
  final TextEditingController controller;

  HexPicker({
    Key key,
    @required this.color,
    @required this.onChanged
  }) : assert(color != null),
        this.controller=new TextEditingController(text: Hex.colorToString(color).toUpperCase()),
        super(key: key);

  @override
  _HexPickerState createState() => new _HexPickerState();
}

class _HexPickerState extends State<HexPicker> {

  void textOnSubmitted(String value) =>super.widget.onChanged(this.textOnChenged(value));
  Color textOnChenged(String text){
    String hex = Hex.textSubString(text);
    if (hex == null) return super.widget.color;

    try{
      return Hex.intToColor(Hex.stringToInt(hex));
    }
    catch (Exception){
      return super.widget.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Text
          new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: new Text(
                "#",
                style: Theme.of(context).textTheme.title.copyWith(fontSize: 18),
              )
          ),

          //TextField
          new Expanded(
              child: new TextField(
                style: Theme.of(context).textTheme.headline.copyWith(fontSize: 20),
                focusNode: new FocusNode()..addListener(() {}),
                controller: super.widget.controller,
                onSubmitted: this.textOnSubmitted,
                decoration: new InputDecoration.collapsed(
                    hintText: "hex code"
                ),
              )
          )

        ]
    );
  }

}


//
//
//---------------------------HexPicker.dart-------------------------------










//---------------------------AlphaPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "SliderPicker.dart";


class AlphaPicker extends StatefulWidget {

  final int alpha;
  final ValueChanged<int> onChanged;

  const AlphaPicker({
    Key key,
    @required this.alpha,
    @required this.onChanged,
  }) : assert(alpha != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _AlphaPickerState();
}

class _AlphaPickerState extends State<AlphaPicker> {

  void valueOnChanged(double ratio) {
    super.widget.onChanged(ratio.toInt());
  }


  Widget buildTitle(String title, String text){
    return new SizedBox(
        height: 34.0,
        child: new Row(
            children: <Widget>[
              new Opacity(
                  opacity: 0.5,
                  child: new Text(
                      title,
                      style: Theme.of(context).textTheme.title
                  )
              ),
              new Expanded(
                  child: new Align(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        text,
                        style: Theme.of(context).textTheme.headline.copyWith(fontSize: 18),
                      )
                  )
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          //Alpha
          this.buildTitle("A", super.widget.alpha.toString()),
          new SliderPicker(
              value: super.widget.alpha.toDouble(),
              min: 0.0,
              max: 255.0,
              onChanged: this.valueOnChanged,
              child: new CustomPaint(
                painter: new AlphaTrackPainter(),
              )
          )

        ]
    );
  }
}


/// Track
class AlphaTrackPainter extends CustomPainter  {

  @override
  void paint(Canvas canvas, Size size) {

    double side=size.height/ 2;
    Paint paint=Paint()..color=Colors.black12;

    for (int i = 0; i * side < size.width; i++) {
      if (i%2==0) canvas.drawRect(Rect.fromLTWH(i * side, 0, side, side), paint);
      else canvas.drawRect(Rect.fromLTWH(i * side, side, side, side), paint);
    }

    Rect rect = Offset.zero & size;
    Gradient gradient = LinearGradient(colors: const[Colors.transparent, Colors.grey]);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


//
//
//---------------------------AlphaPicker.dart-------------------------------










//---------------------------SwatchesPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import 'package:flutter/services.dart';
//import "SliderPicker.dart";

class SwatchesPicker extends StatefulWidget {

  final ValueChanged<Color> onChanged;

  SwatchesPicker({
    Key key,
    @required this.onChanged
  }) : super(key: key);

  @override
  _SwatchesPickerState createState() => new _SwatchesPickerState();
}

class _SwatchesPickerState extends State<SwatchesPicker> with SingleTickerProviderStateMixin {

  TabController controller;

  void itemClick(Color item)=>super.widget.onChanged(item);

  @override
  void initState(){
    super.initState();

    this.controller=new TabController(
      initialIndex: 1,
      length: swatches.length,
      vsync: this
    );
  }

  Widget buildListView(Color item){
    if(item==null) return Divider(height: 60.0);

    return new Container(
      width: 40.0,
      height: 40.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: item,
        shape: BoxShape.circle,
        border: new Border.all(color: Colors.grey, width: 1)
      ),
      child: new InkWell(
        borderRadius: new BorderRadius.all(new Radius.circular(20)),
        onTap: ()=>this.itemClick(item),
        splashColor: item
      )
    );
  }



  @override
  Widget build(BuildContext context){
    return new SafeArea(
        child: new Container(
            width: 470.0,
            height: 333.0,
            child: new GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                children: swatches.map(this.buildListView).toList()
            )
        )
    );
  }
}





List<Color> swatches = [
  //[
  Colors.transparent, //transparent
  Colors.black, //black
  Colors.black87, //black87
  Colors.black54, //black54
  Colors.black45, //black45
  Colors.black38, //black38
  Colors.black26, //black26
  Colors.black12, //black12
  Colors.white, //white
  Colors.white70, //white70
  Colors.white54, //white54
  Colors.white30, //white30
  Colors.white24, //white24
  Colors.white12, //white12
  Colors.white10, //white10
  //], [
  Colors.red, //red
  Colors.pink, //pink
  Colors.purple, //purple
  Colors.deepPurple, //deepPurple
  Colors.indigo, //indigo
  Colors.blue, //blue
  Colors.lightBlue, //lightBlue
  Colors.cyan, //cyan
  Colors.teal, //teal
  Colors.green, //green
  Colors.lightGreen, //lightGreen
  Colors.lime, //lime
  Colors.yellow, //yellow
  Colors.amber, //amber
  Colors.orange, //orange
  Colors.deepOrange, //deepOrange
  Colors.brown, //brown
  Colors.grey, //grey
  Colors.blueGrey, //blueGrey
  //null,
  Colors.redAccent, //redAccent
  Colors.pinkAccent, //pinkAccent
  Colors.purpleAccent, //purpleAccent
  Colors.deepPurpleAccent, //deepPurpleAccent
  Colors.indigoAccent, //indigoAccent
  Colors.blueAccent, //blueAccent
  Colors.lightBlueAccent, //lightBlueAccent
  Colors.cyanAccent, //cyanAccent
  Colors.tealAccent, //tealAccent
  Colors.greenAccent, //greenAccent
  Colors.lightGreenAccent, //lightGreenAccent
  Colors.limeAccent, //limeAccent
  Colors.yellowAccent, //yellowAccent
  Colors.amberAccent, //amberAccent
  Colors.orangeAccent, //orangeAccent
  Colors.deepOrangeAccent, //deepOrangeAccent
  //], [
  Colors.red[50], //red[50]
  Colors.red[100], //red[100]
  Colors.red[200], //red[200]
  Colors.red[300], //red[300]
  Colors.red[400], //red[400]
  Colors.red[500], //red[500]
  Colors.red[600], //red[600]
  Colors.red[700], //red[700]
  Colors.red[800], //red[800]
  Colors.red[900], //red[900]
  //null,
  Colors.redAccent[100], //redAccent[100]
  Colors.redAccent[200], //redAccent[200]
  Colors.redAccent[400], //redAccent[400]
  Colors.redAccent[700], //redAccent[700]
  //], [
  Colors.pink[50], //pink[50]
  Colors.pink[100], //pink[100]
  Colors.pink[200], //pink[200]
  Colors.pink[300], //pink[300]
  Colors.pink[400], //pink[400]
  Colors.pink[500], //pink[500]
  Colors.pink[600], //pink[600]
  Colors.pink[700], //pink[700]
  Colors.pink[800], //pink[800]
  Colors.pink[900], //pink[900]
  //null,
  Colors.pinkAccent[100], //pinkAccent[100]
  Colors.pinkAccent[200], //pinkAccent[200]
  Colors.pinkAccent[400], //pinkAccent[400]
  Colors.pinkAccent[700], //pinkAccent[700]
  //], [
  Colors.purple[50], //purple[50]
  Colors.purple[100], //purple[100]
  Colors.purple[200], //purple[200]
  Colors.purple[300], //purple[300]
  Colors.purple[400], //purple[400]
  Colors.purple[500], //purple[500]
  Colors.purple[600], //purple[600]
  Colors.purple[700], //purple[700]
  Colors.purple[800], //purple[800]
  Colors.purple[900], //purple[900]
  //null,
  Colors.purpleAccent[100], //purpleAccent[100]
  Colors.purpleAccent[200], //purpleAccent[200]
  Colors.purpleAccent[400], //purpleAccent[400]
  Colors.purpleAccent[700], //purpleAccent[700]
  //], [
  Colors.deepPurple[50], //deepPurple[50]
  Colors.deepPurple[100], //deepPurple[100]
  Colors.deepPurple[200], //deepPurple[200]
  Colors.deepPurple[300], //deepPurple[300]
  Colors.deepPurple[400], //deepPurple[400]
  Colors.deepPurple[500], //deepPurple[500]
  Colors.deepPurple[600], //deepPurple[600]
  Colors.deepPurple[700], //deepPurple[700]
  Colors.deepPurple[800], //deepPurple[800]
  Colors.deepPurple[900], //deepPurple[900]
  //null,
  Colors.deepPurpleAccent[100], //deepPurpleAccent[100]
  Colors.deepPurpleAccent[200], //deepPurpleAccent[200]
  Colors.deepPurpleAccent[400], //deepPurpleAccent[400]
  Colors.deepPurpleAccent[700], //deepPurpleAccent[700]
  //], [
  Colors.indigo[50], //indigo[50]
  Colors.indigo[100], //indigo[100]
  Colors.indigo[200], //indigo[200]
  Colors.indigo[300], //indigo[300]
  Colors.indigo[400], //indigo[400]
  Colors.indigo[500], //indigo[500]
  Colors.indigo[600], //indigo[600]
  Colors.indigo[700], //indigo[700]
  Colors.indigo[800], //indigo[800]
  Colors.indigo[900], //indigo[900]
  //null,
  Colors.indigoAccent[100], //indigoAccent[100]
  Colors.indigoAccent[200], //indigoAccent[200]
  Colors.indigoAccent[400], //indigoAccent[400]
  Colors.indigoAccent[700], //indigoAccent[700]
  //], [
  Colors.blue[50], //blue[50]
  Colors.blue[100], //blue[100]
  Colors.blue[200], //blue[200]
  Colors.blue[300], //blue[300]
  Colors.blue[400], //blue[400]
  Colors.blue[500], //blue[500]
  Colors.blue[600], //blue[600]
  Colors.blue[700], //blue[700]
  Colors.blue[800], //blue[800]
  Colors.blue[900], //blue[900]
  //null,
  Colors.blueAccent[100], //blueAccent[100]
  Colors.blueAccent[200], //blueAccent[200]
  Colors.blueAccent[400], //blueAccent[400]
  Colors.blueAccent[700], //blueAccent[700]
  //], [
  Colors.lightBlue[50], //lightBlue[50]
  Colors.lightBlue[100], //lightBlue[100]
  Colors.lightBlue[200], //lightBlue[200]
  Colors.lightBlue[300], //lightBlue[300]
  Colors.lightBlue[400], //lightBlue[400]
  Colors.lightBlue[500], //lightBlue[500]
  Colors.lightBlue[600], //lightBlue[600]
  Colors.lightBlue[700], //lightBlue[700]
  Colors.lightBlue[800], //lightBlue[800]
  Colors.lightBlue[900], //lightBlue[900]
  //null,
  Colors.lightBlueAccent[100], //lightBlueAccent[100]
  Colors.lightBlueAccent[200], //lightBlueAccent[200]
  Colors.lightBlueAccent[400], //lightBlueAccent[400]
  Colors.lightBlueAccent[700], //lightBlueAccent[700]
  //], [
  Colors.cyan[50], //cyan[50]
  Colors.cyan[100], //cyan[100]
  Colors.cyan[200], //cyan[200]
  Colors.cyan[300], //cyan[300]
  Colors.cyan[400], //cyan[400]
  Colors.cyan[500], //cyan[500]
  Colors.cyan[600], //cyan[600]
  Colors.cyan[700], //cyan[700]
  Colors.cyan[800], //cyan[800]
  Colors.cyan[900], //cyan[900]
  //null,
  Colors.cyanAccent[100], //cyanAccent[100]
  Colors.cyanAccent[200], //cyanAccent[200]
  Colors.cyanAccent[400], //cyanAccent[400]
  Colors.cyanAccent[700], //cyanAccent[700]
  //], [
  Colors.teal[50], //teal[50]
  Colors.teal[100], //teal[100]
  Colors.teal[200], //teal[200]
  Colors.teal[300], //teal[300]
  Colors.teal[400], //teal[400]
  Colors.teal[500], //teal[500]
  Colors.teal[600], //teal[600]
  Colors.teal[700], //teal[700]
  Colors.teal[800], //teal[800]
  Colors.teal[900], //teal[900]
  //null,
  Colors.tealAccent[100], //tealAccent[100]
  Colors.tealAccent[200], //tealAccent[200]
  Colors.tealAccent[400], //tealAccent[400]
  Colors.tealAccent[700], //tealAccent[700]
  //], [
  Colors.green[50], //green[50]
  Colors.green[100], //green[100]
  Colors.green[200], //green[200]
  Colors.green[300], //green[300]
  Colors.green[400], //green[400]
  Colors.green[500], //green[500]
  Colors.green[600], //green[600]
  Colors.green[700], //green[700]
  Colors.green[800], //green[800]
  Colors.green[900], //green[900]
  //null,
  Colors.greenAccent[100], //greenAccent[100]
  Colors.greenAccent[200], //greenAccent[200]
  Colors.greenAccent[400], //greenAccent[400]
  Colors.greenAccent[700], //greenAccent[700]
  //], [
  Colors.lightGreen[50], //lightGreen[50]
  Colors.lightGreen[100], //lightGreen[100]
  Colors.lightGreen[200], //lightGreen[200]
  Colors.lightGreen[300], //lightGreen[300]
  Colors.lightGreen[400], //lightGreen[400]
  Colors.lightGreen[500], //lightGreen[500]
  Colors.lightGreen[600], //lightGreen[600]
  Colors.lightGreen[700], //lightGreen[700]
  Colors.lightGreen[800], //lightGreen[800]
  Colors.lightGreen[900], //lightGreen[900]
  //null,
  Colors.lightGreenAccent[100], //lightGreenAccent[100]
  Colors.lightGreenAccent[200], //lightGreenAccent[200]
  Colors.lightGreenAccent[400], //lightGreenAccent[400]
  Colors.lightGreenAccent[700], //lightGreenAccent[700]
  //], [
  Colors.lime[50], //lime[50]
  Colors.lime[100], //lime[100]
  Colors.lime[200], //lime[200]
  Colors.lime[300], //lime[300]
  Colors.lime[400], //lime[400]
  Colors.lime[500], //lime[500]
  Colors.lime[600], //lime[600]
  Colors.lime[700], //lime[700]
  Colors.lime[800], //lime[800]
  Colors.lime[900], //lime[900]
  //null,
  Colors.limeAccent[100], //limeAccent[100]
  Colors.limeAccent[200], //limeAccent[200]
  Colors.limeAccent[400], //limeAccent[400]
  Colors.limeAccent[700], //limeAccent[700]
  //], [
  Colors.yellow[50], //yellow[50]
  Colors.yellow[100], //yellow[100]
  Colors.yellow[200], //yellow[200]
  Colors.yellow[300], //yellow[300]
  Colors.yellow[400], //yellow[400]
  Colors.yellow[500], //yellow[500]
  Colors.yellow[600], //yellow[600]
  Colors.yellow[700], //yellow[700]
  Colors.yellow[800], //yellow[800]
  Colors.yellow[900], //yellow[900]
  //null,
  Colors.yellowAccent[100], //yellowAccent[100]
  Colors.yellowAccent[200], //yellowAccent[200]
  Colors.yellowAccent[400], //yellowAccent[400]
  Colors.yellowAccent[700], //yellowAccent[700]
  //], [
  Colors.amber[50], //amber[50]
  Colors.amber[100], //amber[100]
  Colors.amber[200], //amber[200]
  Colors.amber[300], //amber[300]
  Colors.amber[400], //amber[400]
  Colors.amber[500], //amber[500]
  Colors.amber[600], //amber[600]
  Colors.amber[700], //amber[700]
  Colors.amber[800], //amber[800]
  Colors.amber[900], //amber[900]
  //null,
  Colors.amberAccent[100], //amberAccent[100]
  Colors.amberAccent[200], //amberAccent[200]
  Colors.amberAccent[400], //amberAccent[400]
  Colors.amberAccent[700], //amberAccent[700]
  //], [
  Colors.orange[50], //orange[50]
  Colors.orange[100], //orange[100]
  Colors.orange[200], //orange[200]
  Colors.orange[300], //orange[300]
  Colors.orange[400], //orange[400]
  Colors.orange[500], //orange[500]
  Colors.orange[600], //orange[600]
  Colors.orange[700], //orange[700]
  Colors.orange[800], //orange[800]
  Colors.orange[900], //orange[900]
  //null,
  Colors.orangeAccent[100], //orangeAccent[100]
  Colors.orangeAccent[200], //orangeAccent[200]
  Colors.orangeAccent[400], //orangeAccent[400]
  Colors.orangeAccent[700], //orangeAccent[700]
  //], [
  Colors.deepOrange[50], //deepOrange[50]
  Colors.deepOrange[100], //deepOrange[100]
  Colors.deepOrange[200], //deepOrange[200]
  Colors.deepOrange[300], //deepOrange[300]
  Colors.deepOrange[400], //deepOrange[400]
  Colors.deepOrange[500], //deepOrange[500]
  Colors.deepOrange[600], //deepOrange[600]
  Colors.deepOrange[700], //deepOrange[700]
  Colors.deepOrange[800], //deepOrange[800]
  Colors.deepOrange[900], //deepOrange[900]
  //null,
  Colors.deepOrangeAccent[100], //deepOrangeAccent[100]
  Colors.deepOrangeAccent[200], //deepOrangeAccent[200]
  Colors.deepOrangeAccent[400], //deepOrangeAccent[400]
  Colors.deepOrangeAccent[700], //deepOrangeAccent[700]
  //], [
  Colors.brown[50], //brown[50]
  Colors.brown[100], //brown[100]
  Colors.brown[200], //brown[200]
  Colors.brown[300], //brown[300]
  Colors.brown[400], //brown[400]
  Colors.brown[500], //brown[500]
  Colors.brown[600], //brown[600]
  Colors.brown[700], //brown[700]
  Colors.brown[800], //brown[800]
  Colors.brown[900], //brown[900]
  //], [
  Colors.grey[50], //grey[50]
  Colors.grey[100], //grey[100]
  Colors.grey[200], //grey[200]
  Colors.grey[300], //grey[300]
  Colors.grey[400], //grey[400]
  Colors.grey[500], //grey[500]
  Colors.grey[600], //grey[600]
  Colors.grey[700], //grey[700]
  Colors.grey[800], //grey[800]
  Colors.grey[900], //grey[900]
  //], [
  Colors.blueGrey[50], //blueGrey[50]
  Colors.blueGrey[100], //blueGrey[100]
  Colors.blueGrey[200], //blueGrey[200]
  Colors.blueGrey[300], //blueGrey[300]
  Colors.blueGrey[400], //blueGrey[400]
  Colors.blueGrey[500], //blueGrey[500]
  Colors.blueGrey[600], //blueGrey[600]
  Colors.blueGrey[700], //blueGrey[700]
  Colors.blueGrey[800], //blueGrey[800]
  Colors.blueGrey[900], //blueGrey[900]
  //]
];




//
//
//---------------------------SwatchesPicker.dart-------------------------------










//---------------------------ColorPicker.dart-------------------------------
//
//

//import "package:flutter/material.dart";
//import "package:color_picker/Pickers/SwatchesPicker.dart";
//import "package:color_picker/Pickers/RGBPicker.dart";
//import "package:color_picker/Pickers/HSVPicker.dart";
//import "package:color_picker/Pickers/WheelPicker.dart";
//import "package:color_picker/Pickers/PaletteHuePicker.dart";
//import "package:color_picker/Pickers/PaletteSaturationPicker.dart";
//import "package:color_picker/Pickers/PaletteValuePicker.dart";
//import "package:color_picker/Pickers/HexPicker.dart";
//import "package:color_picker/Pickers/AlphaPicker.dart";

class _IPicker{
  int index;
  String name;
  WidgetBuilder builder;

  _IPicker({
    @required this.index,
    @required this.name,
    @required this.builder
  });
}

class ColorPicker extends StatefulWidget {

  final Color color;
  final ValueChanged<Color> onChanged;

  const ColorPicker({
    Key key,
    this.color = Colors.blue,
    @required this.onChanged
  }): super(key: key);

  @override
  ColorPickerState createState() => new ColorPickerState(color:  this.color);
}

class ColorPickerState extends State<ColorPicker> {

  //Color
  int _alpha;
  Color _color;
  HSVColor _hSVColor;

  Color get color=>this.color;
  set color(Color value)=>this.color=value;

  ColorPickerState({
    Color color
  }) : this._alpha=color.alpha,
        this._color=color,
        this._hSVColor=HSVColor.fromColor(color);

  void _alphaOnChanged(int value) {
    this._alpha=value;
    super.widget.onChanged(this._color.withAlpha(value));
  }
  void _colorOnChanged(Color value){
    this._color=value;
    this._hSVColor=HSVColor.fromColor(value);
    super.widget.onChanged(value);
  }
  void _hSVColorOnChanged(HSVColor value){
    this._color=value.toColor();
    this._hSVColor=value;
    super.widget.onChanged(value.toColor());
  }
  void _colorWithAlphaOnChanged(Color value){
    this._alpha=value.alpha;
    Color color=value.withAlpha(255);
    this._color=color;
    this._hSVColor=HSVColor.fromColor(color);
    super.widget.onChanged(value);
  }


  //pickers
  int _index = 4;
  List<_IPicker> _pickers;
  void _pickerOnChanged(_IPicker value) => this._index=this._pickers.indexOf(value);


  @override
  void initState(){
    super.initState();

    //pickers
    this._pickers = [

      //SwatchesPicker
      new _IPicker(
          index: 0,
          name: "Swatches",
          builder: (context)=>new SwatchesPicker(
            onChanged: (value)=>super.setState(()=>this._colorWithAlphaOnChanged(value)),
          )
      ),

      //RGBPicker
      new _IPicker(
          index: 1,
          name: "RGB",
          builder: (context)=>new RGBPicker(
            color: this._color,
            onChanged: (value)=>super.setState(()=>this._colorOnChanged(value)),
          )
      ),

      //HSVPicker
      new _IPicker(
          index: 2,
          name: "HSV",
          builder: (context)=>new HSVPicker(
            color: this._hSVColor,
            onChanged: (value)=>super.setState(()=>this._hSVColorOnChanged(value)),
          )
      ),

      //WheelPicker
      new _IPicker(
          index: 3,
          name: "Wheel",
          builder: (context)=>new WheelPicker(
            color: this._hSVColor,
            hasPalette: true,
            onChanged: (value)=>super.setState(()=>this._hSVColorOnChanged(value)),
          )
      ),
      //WheelPicker
      new _IPicker(
          index: 4,
          name: "Wheel - no pallete",
          builder: (context)=>new WheelPicker(
            color: this._hSVColor,
            hasPalette: false,
            onChanged: (value)=>super.setState(()=>this._hSVColorOnChanged(value)),
          )
      ),

      //PaletteHuePicker
      new _IPicker(
          index: 5,
          name: "Palette Hue",
          builder: (context)=>new PaletteHuePicker(
            color: this._hSVColor,
            onChanged: (value)=>super.setState(()=>this._hSVColorOnChanged(value)),
          )
      ),

      //PaletteSaturationPicker
      new _IPicker(
          index: 6,
          name: "Palette Saturation",
          builder: (context)=>new PaletteSaturationPicker(
            color: this._hSVColor,
            onChanged: (value)=>super.setState(()=>this._hSVColorOnChanged(value)),
          )
      ),

      //PaletteValuePicker
      new _IPicker(
          index: 7,
          name: "Palette Value",
          builder: (context)=>new PaletteValuePicker(
            color: this._hSVColor,
            onChanged: (value)=>super.setState(()=>this._hSVColorOnChanged(value)),
          )
      ),

    ];
  }


  //Dropdown
  DropdownMenuItem<_IPicker> _buildDropdownMenuItems(_IPicker item) {
    return new DropdownMenuItem<_IPicker>(
        value: item,
        child: new Padding(
            padding: const EdgeInsets.fromLTRB(10.0,8.0,10.0,0.0),
            child: new Text(
              item.name,
              style: this._index==item.index?
              Theme.of(context).textTheme.headline.copyWith(fontSize: 18, color: Theme.of(context).accentColor):
              Theme.of(context).textTheme.headline.copyWith(fontSize: 18),
            )
        )
    );
  }


  Widget _buildHead() {
    return new SizedBox(
        height: 50,
        child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              //Avator
              new Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: new Border.all(color: Colors.black26, width: 1)
                  ),
                  child: new Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(color: Colors.white, width: 3),
                          color: this._color
                      )
                  )
              ),

              new SizedBox(width: 22),

              //HexPicker
              new Expanded(
                  child: new HexPicker(
                    color: this._color,
                    onChanged: (value)=>super.setState(()=>this._colorOnChanged(value)),
                  )
              )

            ]
        )
    );
  }

  Widget _buildDropdown() {
    return new SizedBox(
        height: 38,
        child: Material(

            type: MaterialType.button,
            color: Theme.of(context).cardColor,
            shadowColor: Colors.black26,
            elevation: 4.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),

            child: new DropdownButton<_IPicker>(
                iconSize: 32.0,
                isExpanded: true,
                isDense: true,
                style: Theme.of(context).textTheme.headline.copyWith(fontSize: 20),
                value: this._pickers[this._index],
                onChanged: (value)=>super.setState(()=>this._pickerOnChanged(value)),
                items: this._pickers.map(this._buildDropdownMenuItems).toList()
            )

        )
    );
  }

  Widget _buildDropdown2() {
    return new SizedBox(
        height: 38,
        child: new DecoratedBox(

            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: new Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1
                ),
                borderRadius: const BorderRadius.all(
                    const Radius.circular(3.0)
                )
            ),

            child: new DropdownButton<_IPicker>(
                iconSize: 32.0,
                isExpanded: true,
                isDense: true,
                style: Theme.of(context).textTheme.headline.copyWith(fontSize: 20),
                value: this._pickers[this._index],
                onChanged: (value)=>super.setState(()=>this._pickerOnChanged(value)),
                items: this._pickers.map(this._buildDropdownMenuItems).toList()
            )

        )
    );
  }

  Widget _buildBody() {
    return new Container(
        child: this._pickers[this._index].builder(context)
    );
  }

  Widget _buildAlphaPicker() {
    return new AlphaPicker(
      alpha: this._alpha,
      onChanged: (value)=>super.setState(()=>this._alphaOnChanged(value)),
    );
  }


  @override
  Widget build(BuildContext context) {

    Orientation orientation = MediaQuery.of(context).orientation;
    switch (orientation) {

      case Orientation.portrait:
        return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              this._buildHead(),
              this._buildDropdown2(),
              this._buildBody(),
              this._buildAlphaPicker(),
            ]
        );

      case Orientation.landscape:
        return new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    this._buildHead(),
                    this._buildDropdown(),
                    this._buildAlphaPicker(),
                  ]
              ),
              new Expanded(
                  child: this._buildBody()
              )
            ]
        );

    }

    return new Text("Color Picker");
  }

}


//
//
//---------------------------ColorPicker.dart-------------------------------
