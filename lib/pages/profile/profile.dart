import 'package:ebooks_point_admin/constants/text_strings.dart';
import 'package:ebooks_point_admin/main.dart';
import 'package:ebooks_point_admin/pages/profile/controller/profile_controller.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(Responsive.isMobile(context) ? 10 : 30.0),
            topLeft: Radius.circular(Responsive.isMobile(context) ? 10 : 30.0),
            // bottomLeft: Radius.circular(30.0),
            // topLeft: Radius.circular(30.0),
          ),
          // color: const Color(0xFF21222D),
          // color: const Color.fromARGB(255, 208, 208, 214),
        ),
        child: FutureBuilder<void>(
          future: profileController.getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError ||
                profileController.userInfo.value == null) {
              return const Center(child: Text(ZText.zFailedloadUser));
            } else {
              return Obx(() {
                if (profileController.userInfo.value != null) {
                  // return _buildProfileContent(context);
                  return _buildProfileContent(
                      profileController.userInfo.value!, context);
                } else {
                  return const Center(child: Text(ZText.zUserInfoNull));
                }
              });
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView _buildProfileContent(
      Map<String, dynamic> userInfo, BuildContext context) {
    final ThemeController themeController = Get.find();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: Get.width * 0.2),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'system',
                      child: Text('System'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'light',
                      child: Text('Light'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'dark',
                      child: Text('Dark'),
                    ),
                  ],
                  onSelected: (String mode) {
                    switch (mode) {
                      case 'system':
                        themeController.changeTheme(ThemeMode.system);
                        break;
                      case 'light':
                        themeController.changeTheme(ThemeMode.light);
                        break;
                      case 'dark':
                        themeController.changeTheme(ThemeMode.dark);
                        break;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "profile_image/profile_avatar.png",
            ),
            // const CircleAvatar(
            //   minRadius: 60,
            // ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Ebooks Point",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "User: ${userInfo['username']}",
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${ZText.zFirstName}: ${userInfo['first_name']}',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${ZText.zLastName}: ${userInfo['last_name']}',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${ZText.zEmail}: ${userInfo['email']}',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${ZText.zPhoneNumber}: ${userInfo['phone_number']}',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${ZText.zRole}: ${userInfo['role']}',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
              ),
            ),

            ///log out button
            InkWell(
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text(ZText.zConfirmAction),
                    content: const Text(
                        "Are you sure you want to log out? You need to type in your credentials again for login!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(ZText.zNo),
                      ),
                      TextButton(
                        onPressed: () async {
                          profileController.logout();
                        },
                        child: const Text(ZText.zYes),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 15), // Adjusted button padding
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      30), // Increased border radius for a rounded appearance
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(
                          0, 3), // Added shadow for a raised effect
                    ),
                  ],
                  gradient: const LinearGradient(
                    colors: [Color(0xff5ABD8C), Color(0xff5ABD8C)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 20, // Adjusted icon size
                    ),
                    SizedBox(width: 10),
                    Text(
                      ZText.zLogOut,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Adjusted text size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding:
            //       // EdgeInsets.all(Responsive.isMobile(context) ? 15 : 20.0),
            //       EdgeInsets.all(20.0),
            //   child: const WeightHeightBloodCard(),
            // ),
            SizedBox(
              height: Responsive.isMobile(context) ? 20 : 40,
              // height: 40,
            ),
            // Scheduled()
          ],
        ),
      ),
    );
  }
}
