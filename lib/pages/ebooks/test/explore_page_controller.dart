import 'dart:convert';
import 'dart:developer';
import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/model/test/category_model.dart';
import 'package:ebooks_point_admin/model/test/ebook_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ExplorePageController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<Ebook> books = <Ebook>[].obs;
  RxList<Ebook> displayList = <Ebook>[].obs;
  RxList<Ebook> searchOnlyItemsList =
      <Ebook>[].obs; // New list for searched items

  // for category filter
  RxList<Category> categories = <Category>[].obs;

  RxList<Ebook> premiumBooks = <Ebook>[].obs;
  RxList<Ebook> recentlyViewedBooks = <Ebook>[].obs;
  RxList<Ebook> recommendedBooksList = <Ebook>[].obs;
  RxList<Ebook> recommendedCategoryList = <Ebook>[].obs;

  @override
  void onInit() {
    super.onInit();
    getBooks();
    getCategories();
    getRecommendedBooks();
    getRecommendedCategoryBooks();
  }

   Future<List<Ebook>> fetchEbooks() async {
    try {
      var response = await http.get(Uri.parse(APIService.fetchEbooksURL));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          // If the response is an array of ebooks
          return jsonData.map((ebook) => Ebook.fromJson(ebook)).toList();
        } else if (jsonData is Map) {
          // If the response is a single ebook
          return [Ebook.fromJson(jsonData as Map<String, dynamic>)];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load ebooks: ${response.body}');
      }
    } catch (e) {
      log('Error fetching ebooks: $e');
      throw Exception('Failed to load ebooks: $e');
    }
  }

  Future<void> getBooks() async {
    try {
      books.value = await fetchEbooks();
      displayList.value = books;
    } catch (e) {
      log("$e");
    }
  }

  static Future<List<Category>> fetchCategories() async {
    try {
      var response = await http.get(Uri.parse(APIService.fetchCategories));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return categoryFromJson(jsonEncode(jsonData));
      } else {
        throw Exception('Failed to load categories: ${response.body}');
      }
    } catch (e) {
      log('Error fetching categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<void> getCategories() async {
    try {
      categories.value = await fetchCategories();
    } catch (e) {
      log("$e");
    }
  }

  void updateList(String value) {
    // Filter books based on the search query
    searchOnlyItemsList.value = books
        .where((element) =>
            element.title != null &&
            element.title!.toLowerCase().contains(value.toLowerCase()))
        .toList();

    // Update displayList based on whether search text is present
    displayList.value = value.isEmpty ? books : searchOnlyItemsList;
  }

  void filterByCategory(String categoryName) {
    if (searchController.text.isEmpty) {
      // Filter books from the main list if there's no search text
      displayList.value = books
          .where((element) =>
              element.categoryId ==
              categories
                  .firstWhere(
                      (category) => category.categoryName == categoryName)
                  .categoryId)
          .toList();
    } else {
      // Filter books based on the selected category from either the original list or searched list
      final List<Ebook> sourceList =
          searchOnlyItemsList.isNotEmpty ? searchOnlyItemsList : books;
      displayList.value = sourceList
          .where((element) =>
              element.categoryId ==
              categories
                  .firstWhere(
                      (category) => category.categoryName == categoryName)
                  .categoryId)
          .toList();
    }
  }

  ///recommended
  void getRecommendedBooks() {
    getBooks();
    log("--------start of getRecommendedBooks-----🔥------------");
    log("Recommended list: $recommendedBooksList");
    if (books.isEmpty) return;

    recommendedBooksList.clear(); // Clear previous recommendations

    for (Ebook ebook in books) {
      double totalRating = 0;
      int numRatings = 0;

      if (ebook.reviews != null) {
        for (Reviews review in ebook.reviews!) {
          totalRating += review.rating ?? 0;
          numRatings++;
        }
      }

      if (numRatings > 0) {
        double avgRating = totalRating / numRatings;
        if (avgRating >= 4.0) {
          recommendedBooksList.add(ebook);
        }
      }
    }
    log("-------------🗿------------");
    log("Recommended list: $recommendedBooksList");
  }

  ///recommended category
  void getRecommendedCategoryBooks() {
    log("-------------🔥----start of getRecommendedCategoryBooks--------");
    if (books.isEmpty) return;

    Map<int, List<double>> categoryRatings =
        {}; // Map to store average ratings for each category
    Map<int, int> categoryBookCounts =
        {}; // Map to store the count of books in each category

    // Calculate average rating and count for each category
    for (Ebook ebook in books) {
      int categoryId = ebook.categoryId ?? -1;
      double totalRating = 0;
      int numRatings = 0;

      if (ebook.reviews != null) {
        for (Reviews review in ebook.reviews!) {
          totalRating += review.rating ?? 0;
          numRatings++;
        }
      }

      if (numRatings > 0) {
        double avgRating = totalRating / numRatings;

        // Update categoryRatings and categoryBookCounts maps
        if (!categoryRatings.containsKey(categoryId)) {
          categoryRatings[categoryId] = [avgRating];
          categoryBookCounts[categoryId] = 1;
        } else {
          categoryRatings[categoryId]!.add(avgRating);
          categoryBookCounts[categoryId] =
              (categoryBookCounts[categoryId] ?? 0) + 1;
        }
      }
    }

    // Calculate average rating for each category
    for (int categoryId in categoryRatings.keys) {
      double avgRating = categoryRatings[categoryId]!.reduce((a, b) => a + b) /
          categoryRatings[categoryId]!.length;
      int bookCount = categoryBookCounts[categoryId]!;

      if (avgRating >= 4.0 && bookCount >= 3) {
        // Consider categories with an average rating of 4.0 or higher and at least 3 books
        recommendedCategoryList
            .addAll(books.where((ebook) => ebook.categoryId == categoryId));
      }
    }

    // Remove duplicates
    recommendedCategoryList = recommendedCategoryList.toSet().toList().obs;

    log("Recommended Category list: $recommendedCategoryList");
  }

  Future<void> deleteEbook(int ebookId) async {
    try {
      var response = await http.post(
        Uri.parse(APIService.deleteEbooksURL),
        body: {'ebook_id': ebookId.toString()},
      );
      if (response.statusCode == 200) {
        // Refresh the ebook list after deletion
        fetchEbooks();
      } else {
        log('Failed to delete ebook.');
      }
    } catch (error) {
      log('Error deleting ebook: $error');
    }
  }
}
