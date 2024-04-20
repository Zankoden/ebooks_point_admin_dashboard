import 'package:ebooks_point_admin/pages/profile/profile.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/test_page.dart';
import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const CustomAppBarTitle(
          title: 'Dashboard',
        ),
      ),
      drawer: Responsive.isMobile(context)
          ? const Drawer(
              child: SideMenuBar(),
            )
          : Responsive.isTablet(context)
              ? const Drawer(
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
            if (Responsive.isDesktop(context)) const SideMenuBar(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to Dashboard",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "This is your dashboard where you can manage your ebooks and more.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    LineChartCard()
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
