import 'dart:developer';
import 'package:ebooks_point_admin/pages/profile/profile.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/model/users.dart';
import 'package:ebooks_point_admin/pages/view_users/edit_user_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_network/image_network.dart';

class ViewAllUsersPageController extends GetxController {
  var users = <Users>[].obs;
  var filteredUsers = <Users>[].obs;
  RxBool isSearched = false.obs;
  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    final response = await http.get(Uri.parse(APIService.viewAllUsersURL));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body)['users'];
      log("$responseData");
      users.assignAll(responseData.map((e) => Users.fromJson(e)).toList());
    } else {
      throw Exception('Failed to load users');
    }
  }

  void deleteUser(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(APIService.deleteUserURL),
        body: {'user_id': userId},
      );
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        // If deletion is successful, remove the user from the list
        users.removeWhere((user) => user.userId == userId);
        // Show success message or handle accordingly

        log(responseData['message']);
      } else {
        // Show error message or handle accordingly

        log(responseData['message']);
      }
    } catch (e) {
      // Handle errors

      log('Failed to delete user: $e');
    }
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      // If the query is empty, show all users
      filteredUsers.assignAll(users);
    } else {
      // Filter users based on the query
      filteredUsers.assignAll(users.where((user) =>
          user.firstName!.toLowerCase().contains(query.toLowerCase()) ||
          user.lastName!.toLowerCase().contains(query.toLowerCase()) ||
          user.email!.toLowerCase().contains(query.toLowerCase())));
    }
  }
}

class ViewAllUsersPage extends StatelessWidget {
  final ViewAllUsersPageController controller =
      Get.put(ViewAllUsersPageController());
  // final ViewAllUsersPageController controller =
  //     Get.find<ViewAllUsersPageController>();
  final TextEditingController searchController = TextEditingController();

  ViewAllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: 'All Users'),
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
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) SideMenuBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.isSearched.value = true;
                      controller.searchUsers(value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Expanded(
                  //   child: Obx(
                  //     () => ListView.builder(
                  //       itemCount: controller.isSearched.value == false
                  //           ? controller.users.length
                  //           : controller.filteredUsers.length,
                  //       itemBuilder: (context, index) {
                  //         var user = controller.isSearched.value == false
                  //             ? controller.users[index]
                  //             : controller.filteredUsers[index];
                  //         // return _buildUserListItem(user);
                  //         return UserCard(
                  //           user: user,
                  //           onDelete: controller.deleteUser,
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Obx(
                      () => GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: Responsive.isDesktop(context)
                              ? 0.77
                              : Responsive.isTablet(context)
                                  ? 0.75
                                  : 0.62,
                          crossAxisCount: Responsive.isDesktop(context)
                              ? 3
                              : Responsive.isTablet(context)
                                  ? 3
                                  : 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 1,
                        ),
                        itemCount: controller.isSearched.value == false
                            ? controller.users.length
                            : controller.filteredUsers.length,
                        itemBuilder: (context, index) {
                          var user = controller.isSearched.value == false
                              ? controller.users[index]
                              : controller.filteredUsers[index];
                          return UserCard(
                            user: user,
                            onDelete: controller.deleteUser,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (Responsive.isDesktop(context)) ProfilePage(),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Users user;
  final Function(String) onDelete;

  const UserCard({
    required this.user,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ImageNetwork(
                  image: user.profileImageUrl!, height: 130, width: 130),
              // CircleAvatar(
              //   maxRadius: 60,
              //   backgroundImage: NetworkImage(user.profileImageUrl!),
              // ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Text('Email: ${user.email!}'),
              ),
              Text("Role: ${user.type.toString()}"),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Get.to(() => EditUserPage(user: user));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Confirmation',
                        middleText:
                            'Are you sure you want to delete this user?',
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
                              onDelete(user.userId.toString());
                            },
                            child: const Text('Yes'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
                            },
                            child: const Text('No'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
