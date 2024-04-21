import 'package:ebooks_point_admin/constants/text_strings.dart';
import 'package:ebooks_point_admin/pages/profile/controller/profile_controller.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/themes/controller/theme_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
          ),
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
                const SizedBox(width: 18),
                const Icon(FluentIcons.table_switch_16_filled),
                const SizedBox(width: 15),
                const Text("Switch Modes"),
                const SizedBox(width: 30),
                Obx(
                  () => DropdownButton<ThemeMode>(
                    value: themeController.themeMode.value,
                    onChanged: (ThemeMode? newValue) {
                      if (newValue != null) {
                        themeController.changeTheme(newValue);
                      }
                    },
                    items: ThemeMode.values
                        .map<DropdownMenuItem<ThemeMode>>((ThemeMode mode) {
                      return DropdownMenuItem<ThemeMode>(
                        value: mode,
                        child: Text(mode.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset(
                "profile_image/profile_avatar.png",
                fit: BoxFit.fill,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/default_img.jpg',
                    width: Responsive.bookImageWidth(context),
                    height: Responsive.bookImageHeight(context) * 0.85,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
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
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              '${ZText.zFirstName}: ${userInfo['first_name']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              '${ZText.zLastName}: ${userInfo['last_name']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              '${ZText.zEmail}: ${userInfo['email']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              '${ZText.zPhoneNumber}: ${userInfo['phone_number']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Text(
              '${ZText.zRole}: ${userInfo['role']}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
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
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      ZText.zLogOut,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 20 : 40,
            ),
          ],
        ),
      ),
    );
  }
}
