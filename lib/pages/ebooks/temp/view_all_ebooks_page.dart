// import 'dart:developer';
// import 'package:ebooks_point_admin/pages/profile/profile.dart';
// import 'package:ebooks_point_admin/responsive.dart';
// import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
// import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:ebooks_point_admin/api/api_services.dart';
// import 'package:ebooks_point_admin/pages/ebooks/edit_ebooks.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ViewAllEbooksPageController extends GetxController {
//   var ebooks = [].obs;
//   var filteredEbooks = [].obs;
//   RxBool isSearched = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchEbooks();
//     // Call searchEbooks with an empty query to show all ebooks by default
//     // searchEbooks('');
//   }

//   Future<void> fetchEbooks() async {
//     try {
//       var response = await http.get(Uri.parse(APIService.fetchEbooksURL));
//       var jsonResponse = jsonDecode(response.body);
//       ebooks.value = jsonResponse;
//     } catch (error) {
//       log("Error fetching ebooks: $error");
//     }
//   }

//   Future<void> deleteEbook(int ebookId) async {
//     try {
//       var response = await http.post(
//         Uri.parse(APIService.deleteEbooksURL),
//         body: {'ebook_id': ebookId.toString()},
//       );
//       if (response.statusCode == 200) {
//         // Refresh the ebook list after deletion
//         fetchEbooks();
//       } else {
//         log('Failed to delete ebook.');
//       }
//     } catch (error) {
//       log('Error deleting ebook: $error');
//     }
//   }

//   void searchEbooks(String query) {
//     if (query.isEmpty) {
//       // If the query is empty, show all ebooks
//       filteredEbooks.assignAll(ebooks);
//     } else {
//       // Filter ebooks based on the query
//       filteredEbooks.assignAll(ebooks.where((ebook) =>
//           ebook['title'].toLowerCase().contains(query.toLowerCase()) ||
//           ebook['author_name'].toLowerCase().contains(query.toLowerCase())));
//     }
//   }
// }

// class ViewAllEbooksPage extends StatelessWidget {
//   final controller = Get.put(ViewAllEbooksPageController());
//   final TextEditingController searchController = TextEditingController();

//   ViewAllEbooksPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.find<ViewAllEbooksPageController>().fetchEbooks();
//     return Scaffold(
//       appBar: AppBar(
//         title: const CustomAppBarTitle(title: 'All Ebooks'),
//       ),
//       body: Row(
//         children: [
//           if (Responsive.isDesktop(context)) const SideMenuBar(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   _buildSearchTextField(),
//                   const SizedBox(height: 20),
//                   Expanded(
//                     child: _buildEbooksGrid(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (Responsive.isDesktop(context)) const ProfilePage(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchTextField() {
//     return TextField(
//       controller: searchController,
//       decoration: const InputDecoration(
//         labelText: 'Search',
//         prefixIcon: Icon(Icons.search),
//         border: OutlineInputBorder(),
//       ),
//       onChanged: (value) {
//         controller.isSearched.value = true;
//         controller.searchEbooks(value);
//       },
//     );
//   }

//   Widget _buildEbooksGrid() {
//     return Obx(() {
//       // if (controller.filteredEbooks.isEmpty) {
//       //   return const Center(
//       //     child: Text('No ebooks found'),
//       //   );
//       // } else {
//       return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 4,
//           crossAxisSpacing: 10.0,
//           mainAxisSpacing: 10.0,
//           childAspectRatio: 0.6,
//         ),
//         itemCount: controller.isSearched.value == false
//             ? controller.ebooks.length
//             : controller.filteredEbooks.length,
//         itemBuilder: (context, index) {
//           var ebook = controller.isSearched.value == false
//               ? controller.ebooks[index]
//               : controller.filteredEbooks[index];
//           return EbookCard(ebook: ebook);
//         },
//       );
//       // }
//     });
//   }
// }

// class EbookCard extends StatelessWidget {
//   final Map<String, dynamic> ebook;

//   const EbookCard({super.key, required this.ebook});

//   @override
//   Widget build(BuildContext context) {
//     // final controller = Get.find<ViewAllEbooksPageController>();

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: InkWell(
//         onTap: () {
//           Get.to(EditEbookPage(
//             // title: ebook['title'],
//             // description: ebook['description'],
//             // thumbnailUrl: ebook['thumbnailUrl'],
//             // pdfUrl: ebook['pdfUrl'],
//             ebookId: ebook['ebookId'],
//           ));
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image.network(
//                   ebook['thumbnailUrl'] ?? '',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 ebook['title'] ?? '',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             ButtonBar(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () {
//                     Get.to(EditEbookPage(ebookId: ebook['ebook_id']));
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () {
//                     _showDeleteConfirmationDialog(context, ebook['ebook_id']);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmationDialog(BuildContext context, int ebookId) {
//     final controller = Get.find<ViewAllEbooksPageController>();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirmation'),
//           content: const Text('Are you sure you want to delete this ebook?'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 // Close the dialog and delete ebook
//                 controller.deleteEbook(ebookId);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Yes'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Close the dialog
//                 Navigator.of(context).pop();
//               },
//               child: const Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
