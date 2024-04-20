import 'package:ebooks_point_admin/my_app.dart';
import 'package:ebooks_point_admin/themes/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeController themeController = Get.put(ThemeController());
  runApp(
    MyApp(themeController: themeController),
  );
}

// extension DarkMode on BuildContext {
//   /// is dark mode currently enabled?
//   bool get isDarkModeHai {
//     final brightness = MediaQuery.of(this).platformBrightness;
//     return brightness == Brightness.dark;
//   }
// }