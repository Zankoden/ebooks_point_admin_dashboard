import 'package:ebooks_point_admin/pages/ebooks/edit_ebooks/controllers/edit_ebook_controller.dart';
import 'package:ebooks_point_admin/pages/profile/profile.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditEbookPage extends StatelessWidget {
  final int ebookId;

  const EditEbookPage({super.key, required this.ebookId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditEbookPageController());

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchEbookDetails(ebookId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: "Edit Ebook Details"),
      ),
      drawer: Responsive.isMobile(context)
          ?  Drawer(
              child: SideMenuBar(),
            )
          : null,
      endDrawer: Responsive.isMobile(context)
          ? Drawer(
              child: ProfilePage(),
            )
          : null,
      body: Row(
        children: [
          if (Responsive.isDesktop(context))  SideMenuBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.updateEbookDetails(ebookId);
                    },
                    child: const Text('Save Changes'),
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
