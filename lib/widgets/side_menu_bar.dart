import 'package:ebooks_point_admin/model/side_menu_items.dart';
import 'package:ebooks_point_admin/pages/profile/controller/profile_controller.dart';
import 'package:ebooks_point_admin/pages/view_users/view_users_page.dart';
import 'package:ebooks_point_admin/routes/router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenuBar extends StatelessWidget {
  SideMenuBar({super.key});

  final c = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    // final bool isAdmin = c.userInfo.value!['type'] == 'admin';
    // final bool isAuthor = c.userInfo.value!['type'] == 'author';

    final bool isAdmin =
        c.userInfo.value != null && c.userInfo.value!['type'] == 'admin';
    final bool isAuthor =
        c.userInfo.value != null && c.userInfo.value!['type'] == 'author';

    if (c.userInfo.value == null || c.userInfo.value!.isEmpty) {
      return const CircularProgressIndicator();
    }

    final List<SideMenuItems> menuItems = [
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
            // Get.put(ExplorePageController());
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
          },
          index: 2,
        ),
    ];
    return Card(
      elevation: 5,
      child: Container(
        width: 250,
        decoration: const BoxDecoration(
            // color: Color(0xFF21222D),
            // color: Color(0xFF171821),
            // color: Colors.grey[200],
            // border: Border.all(color: Colors.grey[300]!),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300]),
            for (int i = 0; i < menuItems.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SideMenuItems(
                  title: menuItems[i].title,
                  icon: menuItems[i].icon,
                  onTap: menuItems[i].onTap, // Directly call onTap function
                  index: i, // Pass the index here
                ),
              ),
          ],
        ),
      ),
    );
  }
}
