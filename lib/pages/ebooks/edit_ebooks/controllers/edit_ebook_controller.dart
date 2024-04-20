import 'dart:convert';

import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/pages/ebooks/controllers/admin/explore_page_controller.dart';
import 'package:ebooks_point_admin/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditEbookPageController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var ebookDetails = {}.obs;

  Future<void> fetchEbookDetails(int ebookId) async {
    try {
      final response = await http.post(
        Uri.parse(APIService.fetchEbookByIdURL),
        body: {'ebook_id': ebookId.toString()},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          ebookDetails.value = responseData['ebook'];

          titleController.text = responseData['ebook']['title'];
          descriptionController.text = responseData['ebook']['description'];
        } else {
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to communicate with the server');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> updateEbookDetails(int ebookId) async {
    try {
      final response = await http.post(
        Uri.parse(APIService.editEbooksURL),
        body: {
          'ebook_id': ebookId.toString(),
          'title': titleController.text,
          'description': descriptionController.text,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          Get.toNamed(AppRoutes.viewAllEbooks);

          Get.find<ExplorePageController>().fetchEbooks();

          Get.snackbar('Success', responseData['message']);
        } else {
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to communicate with the server');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
