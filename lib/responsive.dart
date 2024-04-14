import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static double bookImageWidth(BuildContext context) {
    if (isDesktop(context)) {
      return MediaQuery.of(context).size.width * 0.15;
    } else if (isTablet(context)) {
      return MediaQuery.of(context).size.width * 0.2;
    } else {
      return MediaQuery.of(context).size.width * 0.3;
    }
  }

  static double bookImageHeight(BuildContext context) {
    if (isDesktop(context)) {
      return MediaQuery.of(context).size.width * 0.15 * 1.6;
    } else if (isTablet(context)) {
      return MediaQuery.of(context).size.width * 0.2 * 1.6;
    } else {
      return MediaQuery.of(context).size.width * 0.3 * 1.6;
    }
  }
}
