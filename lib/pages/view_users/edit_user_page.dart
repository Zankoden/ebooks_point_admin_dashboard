import 'dart:convert';

import 'package:ebooks_point_admin/pages/profile/profile.dart';
import 'package:ebooks_point_admin/pages/view_users/view_users_page.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/routes/router.dart';
import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/model/users.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditUserPageController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> updateUserDetails(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(APIService.updateUserInfoURL),
        body: {
          'user_id': userId,
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'email': emailController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          Get.toNamed(AppRoutes.viewAllUsersPage);
          Get.find<ViewAllUsersPageController>().fetchUsers();
          // User details updated successfully
          Get.snackbar('Success', responseData['message']);
        } else {
          // Failed to update user details
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        // Server error
        Get.snackbar('Error', 'Failed to communicate with the server');
      }
    } catch (e) {
      // Exception
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}

class EditUserPage extends StatelessWidget {
  final Users user;

  const EditUserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditUserPageController());

    // Set initial values for text fields
    controller.firstNameController.text = user.firstName ?? '';
    controller.lastNameController.text = user.lastName ?? '';
    controller.emailController.text = user.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(
          title: 'Edit User Details',
        ),
      ),
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) const SideMenuBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller.firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: controller.lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Call update function when save button is pressed
                      controller.updateUserDetails(user.userId!);
                    },
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
          if (Responsive.isDesktop(context))  ProfilePage(),
        ],
      ),
    );
  }
}
