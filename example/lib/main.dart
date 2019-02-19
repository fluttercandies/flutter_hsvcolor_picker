import "package:flutter/animation.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/painting.dart";
import "package:flutter/physics.dart";
import "package:flutter/rendering.dart";
import "package:flutter/scheduler.dart";
import "package:flutter/semantics.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter/material.dart";

import "dart:async";
import "dart:ui" as UI;
import "dart:convert" as Convert;
import "dart:math" as Math;
import "MainPage.dart";

void main() {

  // Device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,//▯
    DeviceOrientation.landscapeLeft,//▭
    DeviceOrientation.landscapeRight//▭
  ]); 

 runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MainPage();
  }
}
