import 'dart:async';
import 'package:ebooks_point_admin/pages/auth/views/login_page.dart';
import 'package:ebooks_point_admin/dash_board_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initializeApp();
  }

  Future<void> initializeApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    Timer(const Duration(seconds: 2), () async {
      if (userIsLogged(userId)) {
        Get.offAll(const DashBoardPage());
      } else {
        Get.offAll(LoginPage());
      }
    });
  }

  bool userIsLogged(int? userId) {
    return userId != null;
  }
}
