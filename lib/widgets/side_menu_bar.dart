import 'dart:convert';
import 'dart:developer';
import 'package:ebooks_point_admin/pages/ebooks/controllers/admin/explore_page_controller.dart';
import 'package:ebooks_point_admin/pages/ebooks/controllers/author/view_author_ebooks_controller.dart';
import 'package:http/http.dart' as http;
import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/model/side_menu_items.dart';
import 'package:ebooks_point_admin/pages/view_users/view_users_page.dart';
import 'package:ebooks_point_admin/routes/router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenuBarController extends GetxController {
  Rx<Map<String, dynamic>?> userInfo = Rx<Map<String, dynamic>?>(null);

  late final List<SideMenuItems> menuItems;

  late final BuildContext context;

  SideMenuBarController(this.context);

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
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
          log("Getting the type: ${userInfo.value!['type']}");
          initializeMenuItems();
        } else {
          log('Failed to get user info: ${data['message']}');
        }
      } else {
        log('Failed to get user info');
      }
    }
  }

  void initializeMenuItems() {
    final bool isAdmin = userInfo.value!['type'] == 'admin';
    final bool isAuthor = userInfo.value!['type'] == 'author';

    menuItems = [
      SideMenuItems(
        title: 'Home',
        icon: FluentIcons.home_12_regular,
        onTap: () => Navigator.pushNamed(context, AppRoutes.homePage),
        index: 0,
      ),
      if (isAdmin)
        SideMenuItems(
          title: 'View Users',
          icon: FluentIcons.person_12_regular,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.viewAllUsersPage);
            Get.put(ViewAllUsersPageController());
          },
          index: 1,
        ),
      if (isAdmin)
        SideMenuItems(
          title: 'View All Ebooks',
          icon: FluentIcons.book_16_regular,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.viewAllEbooks);
            Get.put(ExplorePageController());
          },
          index: 2,
        ),
      if (isAuthor)
        SideMenuItems(
          title: 'Upload Ebook Page',
          icon: FluentIcons.arrow_upload_16_regular,
          onTap: () => Navigator.pushNamed(context, AppRoutes.uploadEbookPage),
          index: 3,
        ),
      if (isAuthor)
        SideMenuItems(
          title: 'View Your Ebooks',
          icon: FluentIcons.book_16_regular,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.viewAuthorAllEbooks);
            // Get.put(ViewAuthorEbooksController());
            Get.find<ViewAuthorEbooksController>().fetchEbooks();
          },
          index: 2,
        ),
    ];
  }
}

class SideMenuBar extends StatelessWidget {
  SideMenuBar({super.key});

  final controller = Get.put(SideMenuBarController(Get.context!));

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userInfo.value == null) {
        return const CircularProgressIndicator();
      } else {
        return Card(
          elevation: 5,
          child: Container(
            width: 250,
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Divider(color: Colors.grey[300]),
                for (int i = 0; i < controller.menuItems.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SideMenuItems(
                      title: controller.menuItems[i].title,
                      icon: controller.menuItems[i].icon,
                      onTap: controller.menuItems[i].onTap,
                      index: i,
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    });
  }
}
