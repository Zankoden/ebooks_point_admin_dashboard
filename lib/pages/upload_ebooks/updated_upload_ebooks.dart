import 'dart:developer';
import 'dart:typed_data';

import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/model/category_model.dart';
import 'package:ebooks_point_admin/pages/profile/profile.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/widgets/custom_app_bar_title.dart';
import 'package:ebooks_point_admin/widgets/side_menu_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:shared_preferences/shared_preferences.dart';

class EbookUploadController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Rx<dynamic> thumbnailFile = Rx<dynamic>(null);
  final Rx<dynamic> pdfFile = Rx<dynamic>(null);
  final RxInt selectedCategoryId = RxInt(0);
  final RxBool isUploading = RxBool(false);

  Widget? thumbnailPreview;
  Widget? pdfPreview;

  final RxList<Category> categories = <Category>[].obs;

  final Rx<Category?> selectedCategory = Rx<Category?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCategories(this);
  }

  static Future<void> fetchCategories(EbookUploadController controller) async {
    try {
      var response = await http.get(Uri.parse(APIService.fetchCategories));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Category> fetchedCategories =
            categoryFromJson(jsonEncode(jsonData));

        controller.categories.assignAll(fetchedCategories);
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      log('Error fetching categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<void> pickThumbnail() async {
    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*';
      input.click();
      await input.onChange.first;
      if (input.files!.isEmpty) return;
      final file = input.files!.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      final Uint8List fileBytes = reader.result as Uint8List;
      thumbnailFile.value = file;
      thumbnailPreview = Image.memory(fileBytes, fit: BoxFit.cover);
      update();
    } else {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        thumbnailFile.value = File(result.files.single.path!);
        thumbnailPreview = Image.file(File(result.files.single.path!));
        update();
      }
    }
  }

  Future<void> pickPdf() async {
    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = '.pdf';
      input.click();
      await input.onChange.first;
      if (input.files!.isEmpty) return;
      pdfFile.value = input.files!.first;
      pdfPreview = const Icon(Icons.picture_as_pdf, size: 50);
      update();
    } else {
      final result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result != null) {
        pdfFile.value = File(result.files.single.path!);
        pdfPreview = const Icon(Icons.picture_as_pdf, size: 50);
        update();
      }
    }
  }

  Future<Uint8List> _readFileBytes(dynamic file) async {
    if (kIsWeb) {
      final reader = html.FileReader();
      final completer = Completer<Uint8List>();
      reader.readAsArrayBuffer(file as html.File);
      reader.onLoadEnd.listen((event) {
        completer.complete(reader.result as Uint8List);
      });
      return completer.future;
    } else {
      return File(file.path).readAsBytes();
    }
  }

  Future<void> uploadEbook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      Get.snackbar(
        'Error',
        'User ID not found. Please log in again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        thumbnailFile.value == null ||
        pdfFile.value == null ||
        selectedCategory.value == null) {
      Get.snackbar(
        'Error',
        'All fields are compulsory. Please fill in the details, select a category, and choose thumbnail and PDF files.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isUploading.value = true;
      final url = Uri.parse('${APIService.baseURL}/upload_ebook.php');
      var request = http.MultipartRequest('POST', url)
        ..fields['title'] = titleController.text
        ..fields['description'] = descriptionController.text
        ..fields['category_id'] = selectedCategory.value!.categoryId.toString()
        ..fields['user_id'] = userId.toString();

      final thumbnailBytes = await _readFileBytes(thumbnailFile.value);
      final pdfBytes = await _readFileBytes(pdfFile.value);

      request.files.add(http.MultipartFile.fromBytes(
          'thumbnail', thumbnailBytes,
          filename: 'thumbnail.jpg'));
      request.files.add(
          http.MultipartFile.fromBytes('pdf', pdfBytes, filename: 'ebook.pdf'));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          Get.snackbar('Success', 'Ebook uploaded successfully');
        } else {
          Get.snackbar('Error', 'Failed to upload ebook: ${data['message']}');
        }
      } else {
        Get.snackbar('Error',
            'Failed to upload ebook. Server returned status code: ${response.statusCode}');
      }

      titleController.clear();
      descriptionController.clear();
      thumbnailFile.value = null;
      pdfFile.value = null;
      thumbnailPreview = null;
      pdfPreview = null;
      update();
    } catch (e) {
      log('Error uploading ebook: $e');
      Get.snackbar(
        'Error',
        'An error occurred while uploading the ebook. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }
}

class EbookUploadPage extends StatelessWidget {
  final EbookUploadController controller = Get.put(EbookUploadController());

  EbookUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBarTitle(title: 'Upload Ebook'),
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
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                return Center(
                  child: SizedBox(
                    width: 500,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: controller.titleController,
                              decoration: const InputDecoration(
                                labelText: 'Title',
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: controller.descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Category>(
                              value: controller.selectedCategory.value,
                              onChanged: (Category? value) {
                                if (value != null) {
                                  controller.selectedCategory.value = value;
                                }
                              },
                              items: controller.categories
                                  .map<DropdownMenuItem<Category>>((category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.categoryName.toString()),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Category',
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildElevatedButton(
                              onPressed: () => controller.pickThumbnail(),
                              label: 'Pick Thumbnail',
                              preview: controller.thumbnailPreview,
                            ),
                            // ElevatedButton(
                            //   onPressed: () => controller.pickThumbnail(),
                            //   child: const Text('Pick Thumbnail'),
                            // ),
                            const SizedBox(height: 16),
                            _buildElevatedButton(
                              onPressed: () => controller.pickPdf(),
                              label: 'Pick PDF',
                              preview: controller.pdfPreview,
                            ),
                            // ElevatedButton(
                            //   onPressed: () => controller.pickPdf(),
                            //   child: const Text('Pick PDF'),
                            // ),
                            const SizedBox(height: 16),
                            // ElevatedButton(
                            //   style: const ButtonStyle(
                            //     animationDuration: Durations.long1,
                            //     elevation: MaterialStatePropertyAll(10),
                            //   ),
                            //   onPressed: () => controller.uploadEbook(),
                            //   child: const Text('Upload Ebook'),
                            // ),
                            _buildElevatedButton(
                              onPressed: () => controller.uploadEbook(),
                              label: 'Upload Ebook',
                              isLoading: controller.isUploading.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          if (Responsive.isDesktop(context)) ProfilePage(),
        ],
      ),
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
    Widget? preview,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Center(
        child: Container(
          height: 60,
          width: 500,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (preview != null) preview,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
