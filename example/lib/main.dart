import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
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