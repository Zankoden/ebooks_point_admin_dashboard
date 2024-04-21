import 'dart:convert';
import 'dart:developer';
import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/pages/auth/views/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  Rx<Map<String, dynamic>?> userInfo = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
    update();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    log(userId.toString());
    if (userId != null) {
      userInfo.value = null;

      final response = await http.post(
        Uri.parse(APIService.getUserInfo),
        body: {
          'user_id': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          userInfo.value = data['user_info'];
        } else {
          log('Failed to get user info: ${data['message']}');
        }
      } else {
        log('Failed to get user info');
      }
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    Get.offAll(() => LoginPage());
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    int? userId = prefs2.getInt('user_id');
    log("After log out: $userId");
  }
}
