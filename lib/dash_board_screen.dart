import 'package:ebooks_point_admin/model/side_menu_items.dart';
import 'package:ebooks_point_admin/pages/profile/controller/profile_controller.dart';
import 'package:ebooks_point_admin/pages/profile/profile.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.find<ProfileController>().getUserInfo();
    Get.put(ProfileController());
    Get.put(SideMenuController());

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(
          title: 'Dashboard',
        ),
      ),
      drawer: Responsive.isMobile(context)
          ? Drawer(
              child: SideMenuBar(),
            )
          : Responsive.isTablet(context)
              ? Drawer(
                  child: SideMenuBar(),
                )
              : null,
      endDrawer: Responsive.isMobile(context)
          ? Drawer(
              child: ProfilePage(),
            )
          : Responsive.isTablet(context)
              ? Drawer(
                  child: ProfilePage(),
                )
              : null,
      body: SelectionArea(
        child: Row(
          children: [
            if (Responsive.isDesktop(context)) SideMenuBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Dashboard",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "This is your dashboard where you can manage your ebooks and more.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    // LineChartCard(),
                  ],
                ),
              ),
            ),
            if (Responsive.isDesktop(context)) ProfilePage(),
          ],
        ),
      ),
    );
  }
}
