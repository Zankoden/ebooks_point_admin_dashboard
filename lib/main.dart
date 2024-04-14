// import 'package:ebooks_point_admin/pages/auth/views/login_page.dart';
// import 'package:ebooks_point_admin/dashboard.dart';
// import 'package:ebooks_point_admin/routes/router.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // setPathUrlStrategy();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   int? userId = prefs.getInt('user_id');

//   runApp(MyApp(userId: userId));
// }

// class MyApp extends StatelessWidget {
//   final int? userId;
//   const MyApp({super.key, this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'E books Admin',
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.dark,
//       theme: context.isDarkModeHai
//           ? ThemeData.dark()
//           : ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//               useMaterial3: true,
//             ),
//       initialRoute: '/',
//       getPages: appPageRoute,
//       home: userId != null ? const DashBoardPage() : LoginPage(),
//       // home: const DashBoardPage(),
//       initialBinding: BindingsBuilder(() {
//         Get.lazyPut(() => ThemeController());
//       }),
//     );
//   }
// }

// extension DarkMode on BuildContext {
//   /// is dark mode currently enabled?
//   bool get isDarkModeHai {
//     final brightness = MediaQuery.of(this).platformBrightness;
//     return brightness == Brightness.dark;
//   }
// }

import 'package:ebooks_point_admin/pages/auth/views/login_page.dart';
import 'package:ebooks_point_admin/dashboard.dart';
import 'package:ebooks_point_admin/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('user_id');

  runApp(GetMaterialApp(
    title: 'E books Admin',
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    getPages: appPageRoute,
    home: userId != null ? const DashBoardPage() : LoginPage(),
    // home: const DashBoardPage(),
    initialBinding: BindingsBuilder(() {
      Get.lazyPut(() => ThemeController());
    }),
    builder: (context, child) {
      final themeController = Get.find<ThemeController>();
      return Obx(() {
        final themeMode = themeController.themeMode.value;
        return MaterialApp(
          title: 'E books Admin',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          home: child,
        );
      });
    },
  ));
}

class ThemeController extends GetxController {
  var themeMode = ThemeMode.system.obs;

  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;
  }
}
