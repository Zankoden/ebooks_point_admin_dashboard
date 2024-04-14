import 'package:ebooks_point_admin/pages/ebooks/controller/view_author_ebooks_controller.dart';
import 'package:ebooks_point_admin/pages/ebooks/edit_ebooks.dart';
import 'package:ebooks_point_admin/pages/profile/profile.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAuthorEbooks extends StatelessWidget {
  final ViewAuthorEbooksController controller =
      Get.put(ViewAuthorEbooksController());

  ViewAuthorEbooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Row(
          children: [
            CustomAppBarTitle(title: "Explore"),
          ],
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
      body: Obx(() {
        // Wrap the body with Obx to reactively update UI
        final displayList = controller.displayList;
        final categories = controller.categories;
        final searchController = controller.searchController;

        return Row(
          children: [
            if (Responsive.isDesktop(context)) const SideMenuBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Search Fav Books",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            TextField(
                              controller: searchController,
                              onChanged: (value) =>
                                  controller.updateList(value),
                              decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "eg. Shreemad Bhagwad Geeta...",
                                hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 146, 145, 145),
                                ),
                                prefixIcon: const Icon(Icons.search),
                                prefixIconColor: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: categories
                                        .map(
                                          (category) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: FilterChip(
                                              label: Text(
                                                  category.categoryName ?? ''),
                                              onSelected: (selected) {
                                                controller.filterByCategory(
                                                  category.categoryName!,
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: displayList.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "No Search Result Found",
                                      ),
                                    )
                                  : GridView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio:
                                            Responsive.isDesktop(context)
                                                // ? 0.6
                                                ? 0.55
                                                : Responsive.isTablet(context)
                                                    ? 0.75
                                                    // : 0.7,
                                                    : 0.62,
                                        crossAxisCount:
                                            Responsive.isDesktop(context)
                                                ? 3
                                                : Responsive.isTablet(context)
                                                    ? 3
                                                    : 2,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 1,
                                      ),
                                      itemCount: displayList.length,
                                      itemBuilder: (context, index) {
                                        final ebook = displayList[index];
                                        return SearchGridCell(
                                          index: index,
                                          bookName: ebook.title ?? '',
                                          imagePath: ebook.thumbnailUrl ?? '',
                                          pdfFilePath: ebook.pdfUrl ?? '',
                                          ebookID: ebook.ebookId ?? -1,
                                          description: ebook.description ?? '',
                                          authorName: ebook.authorName ?? '',
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (Responsive.isDesktop(context)) ProfilePage(),
          ],
        );
      }),
    );
  }
}

///
class SearchGridCell extends StatelessWidget {
  final int index;
  final String bookName;
  final String imagePath;
  final String pdfFilePath;
  final int ebookID;
  final String authorName;
  final String description;

  SearchGridCell({
    super.key,
    required this.bookName,
    required this.imagePath,
    required this.pdfFilePath,
    required this.ebookID,
    required this.index,
    required this.description,
    required this.authorName,
  });

  final c = Get.put(ViewAuthorEbooksController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imagePath,
                width: Responsive.bookImageWidth(context),
                height: Responsive.bookImageHeight(context),
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/default_img.jpg',
                    width: Responsive.bookImageWidth(context),
                    height: Responsive.bookImageHeight(context) *
                        0.85, // Adjust height as needed
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Text(
            bookName,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis),
          ),
          Flexible(
            child: Row(
              children: [
                const SizedBox(width: 50),
                Tooltip(
                  message: 'Edit',
                  child: CircleAvatar(
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      color: const Color.fromARGB(255, 126, 121, 70),
                      onPressed: () {
                        Get.to(EditEbookPage(ebookId: ebookID));
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: 'Delete',
                  child: CircleAvatar(
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, ebookID);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int ebookId) {
    final controller = Get.find<ViewAuthorEbooksController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this ebook?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Close the dialog and delete ebook
                controller.deleteEbook(ebookId);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
