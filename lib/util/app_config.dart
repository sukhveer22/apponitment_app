import 'package:flutter/widgets.dart';

class AppConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double devicePixelRatio;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  }

  static double getWidth(double percentage) {
    return screenWidth * percentage / 100;
  }

  static double getHeight(double percentage) {
    return screenHeight * percentage / 100;
  }
}
