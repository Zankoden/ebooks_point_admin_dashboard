import 'package:ebooks_point_admin/routes/router.dart';
import 'package:ebooks_point_admin/themes/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final themeMode = themeController.themeMode.value;
        return GetMaterialApp(
          title: 'E books Admin',
          debugShowCheckedModeBanner: false,
          initialBinding: BindingsBuilder(() {
            Get.lazyPut(() => ThemeController());
          }),
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          initialRoute: '/',
          getPages: appPageRoute,
        );
      },
    );
  }
}
