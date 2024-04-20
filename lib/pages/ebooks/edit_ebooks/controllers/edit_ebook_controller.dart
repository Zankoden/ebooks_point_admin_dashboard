import 'dart:convert';

import 'package:ebooks_point_admin/api/api_services.dart';
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
        Uri.parse(APIService
            .fetchEbookByIdURL), // Replace with your PHP script URL to fetch ebook details
        body: {'ebook_id': ebookId.toString()},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          // Ebook details fetched successfully
          ebookDetails.value = responseData['ebook'];
          // Populate the text fields with fetched data
          titleController.text = responseData['ebook']['title'];
          descriptionController.text = responseData['ebook']['description'];
        } else {
          // Failed to fetch ebook details
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

  Future<void> updateEbookDetails(int ebookId) async {
    try {
      final response = await http.post(
        Uri.parse(APIService.editEbooksURL), // Replace with your PHP script URL
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
          // Ebook details updated successfully
          Get.snackbar('Success', responseData['message']);
        } else {
          // Failed to update ebook details
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
