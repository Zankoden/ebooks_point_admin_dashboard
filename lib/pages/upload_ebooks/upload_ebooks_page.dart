// import 'package:ebooks_point_admin/api/api_services.dart';
// import 'package:ebooks_point_admin/pages/profile/profile.dart';
// import 'package:ebooks_point_admin/responsive.dart';
// import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
// import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html' as html;

// class EbookUploadController extends GetxController {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   final Rx<dynamic> thumbnailFile = Rx<dynamic>(null);
//   final Rx<dynamic> pdfFile = Rx<dynamic>(null);

//   final RxBool isUploading = RxBool(false);

//   Widget? thumbnailPreview;
//   Widget? pdfPreview;

//   Future<void> pickThumbnail() async {
//     if (kIsWeb) {
//       final html.FileUploadInputElement input = html.FileUploadInputElement()
//         ..accept = 'image/*';
//       input.click();
//       await input.onChange.first;
//       if (input.files!.isEmpty) return;
//       final file = input.files!.first;
//       final reader = html.FileReader();
//       reader.readAsArrayBuffer(file);
//       await reader.onLoad.first;
//       final Uint8List fileBytes = reader.result as Uint8List;
//       thumbnailFile.value = file;
//       thumbnailPreview = Image.memory(fileBytes, fit: BoxFit.cover);
//       update();
//     } else {
//       final result = await FilePicker.platform.pickFiles(type: FileType.image);
//       if (result != null) {
//         thumbnailFile.value = File(result.files.single.path!);
//         thumbnailPreview = Image.file(File(result.files.single.path!));
//         update();
//       }
//     }
//   }

//   Future<void> pickPdf() async {
//     if (kIsWeb) {
//       final html.FileUploadInputElement input = html.FileUploadInputElement()
//         ..accept = '.pdf';
//       input.click();
//       await input.onChange.first;
//       if (input.files!.isEmpty) return;
//       pdfFile.value = input.files!.first;
//       pdfPreview = const Icon(Icons.picture_as_pdf, size: 50);
//       update();
//     } else {
//       final result = await FilePicker.platform
//           .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//       if (result != null) {
//         pdfFile.value = File(result.files.single.path!);
//         pdfPreview = const Icon(Icons.picture_as_pdf, size: 50);
//         update();
//       }
//     }
//   }

//   // Helper method to read file bytes
//   Future<Uint8List> _readFileBytes(dynamic file) async {
//     if (kIsWeb) {
//       final reader = html.FileReader();
//       final completer = Completer<Uint8List>();
//       reader.readAsArrayBuffer(file as html.File);
//       reader.onLoadEnd.listen((event) {
//         completer.complete(reader.result as Uint8List);
//       });
//       return completer.future;
//     } else {
//       return File(file.path).readAsBytes();
//     }
//   }

//   Future<void> uploadEbook() async {
//     if (titleController.text.isEmpty ||
//         descriptionController.text.isEmpty ||
//         thumbnailFile.value == null ||
//         pdfFile.value == null) {
//       Get.snackbar(
//         'Error',
//         'All fields are compulsory. Please fill in the details and select thumbnail and PDF files.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     try {
//       isUploading.value = true;
//       final url = Uri.parse('${APIService.baseURL}/upload_ebook.php');
//       var request = http.MultipartRequest('POST', url)
//         ..fields['title'] = titleController.text
//         ..fields['description'] = descriptionController.text;

//       // Handle files
//       final thumbnailBytes = await _readFileBytes(thumbnailFile.value);
//       final pdfBytes = await _readFileBytes(pdfFile.value);

//       request.files.add(http.MultipartFile.fromBytes(
//           'thumbnail', thumbnailBytes,
//           filename: 'thumbnail.jpg'));
//       request.files.add(
//           http.MultipartFile.fromBytes('pdf', pdfBytes, filename: 'ebook.pdf'));

//       final response = await http.Response.fromStream(await request.send());
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success']) {
//           Get.snackbar('Success', 'Ebook uploaded successfully');
//         } else {
//           Get.snackbar('Error', 'Failed to upload ebook: ${data['message']}');
//         }
//       } else {
//         Get.snackbar('Error', 'Failed to upload ebook');
//       }

//       // Reset state after upload
//       titleController.clear();
//       descriptionController.clear();
//       thumbnailFile.value = null;
//       pdfFile.value = null;
//       thumbnailPreview = null;
//       pdfPreview = null;
//       update();
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'An error occurred while uploading the ebook. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isUploading.value = false;
//     }
//   }
// }

// class EbookUploadPage extends StatelessWidget {
//   final EbookUploadController controller = Get.put(EbookUploadController());

//   EbookUploadPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const CustomAppBarTitle(title: 'Upload Ebook'),
//       ),
//       body: Row(
//         children: [
//           if (Responsive.isDesktop(context)) const SideMenuBar(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   _buildTextField(
//                     controller: controller.titleController,
//                     labelText: 'Title',
//                   ),
//                   const SizedBox(height: 16),
//                   _buildTextField(
//                     controller: controller.descriptionController,
//                     labelText: 'Description',
//                   ),
//                   const SizedBox(height: 16),
//                   _buildElevatedButton(
//                     onPressed: () => controller.pickThumbnail(),
//                     label: 'Pick Thumbnail',
//                     preview: controller.thumbnailPreview,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildElevatedButton(
//                     onPressed: () => controller.pickPdf(),
//                     label: 'Pick PDF',
//                     preview: controller.pdfPreview,
//                   ),
//                   const SizedBox(height: 16),
//                   _buildElevatedButton(
//                     onPressed: () => controller.uploadEbook(),
//                     label: 'Upload Ebook',
//                     isLoading: controller.isUploading.value,
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

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: labelText,
//       ),
//     );
//   }

//   Widget _buildElevatedButton({
//     required VoidCallback onPressed,
//     required String label,
//     Widget? preview,
//     bool isLoading = false,
//   }) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         height: 60,
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: isLoading
//               ? const CircularProgressIndicator(
//                   color: Colors.white,
//                 )
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     if (preview != null) preview,
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }
// }
