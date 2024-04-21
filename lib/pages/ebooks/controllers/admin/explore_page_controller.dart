import 'dart:convert';
import 'dart:developer';
import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/model/category_model.dart';
import 'package:ebooks_point_admin/model/ebook_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ExplorePageController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxList<Ebook> books = <Ebook>[].obs;
  RxList<Ebook> displayList = <Ebook>[].obs;
  RxList<Ebook> searchOnlyItemsList = <Ebook>[].obs;

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
      log("All Fetched Ebooks: ${response.body}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          return jsonData.map((ebook) => Ebook.fromJson(ebook)).toList();
        } else if (jsonData is Map) {
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
    searchOnlyItemsList.value = books
        .where((element) =>
            element.title != null &&
            element.title!.toLowerCase().contains(value.toLowerCase()))
        .toList();

    displayList.value = value.isEmpty ? books : searchOnlyItemsList;
  }

  void filterByCategory(String categoryName) {
    if (searchController.text.isEmpty) {
      displayList.value = books
          .where((element) =>
              element.categoryId ==
              categories
                  .firstWhere(
                      (category) => category.categoryName == categoryName)
                  .categoryId)
          .toList();
    } else {
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

  void getRecommendedBooks() {
    getBooks();
    log("--------start of getRecommendedBooks-----🔥------------");
    log("Recommended list: $recommendedBooksList");
    if (books.isEmpty) return;

    recommendedBooksList.clear();

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

  void getRecommendedCategoryBooks() {
    log("-------------🔥----start of getRecommendedCategoryBooks--------");
    if (books.isEmpty) return;

    Map<int, List<double>> categoryRatings = {};
    Map<int, int> categoryBookCounts = {};

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

    for (int categoryId in categoryRatings.keys) {
      double avgRating = categoryRatings[categoryId]!.reduce((a, b) => a + b) /
          categoryRatings[categoryId]!.length;
      int bookCount = categoryBookCounts[categoryId]!;

      if (avgRating >= 4.0 && bookCount >= 3) {
        recommendedCategoryList
            .addAll(books.where((ebook) => ebook.categoryId == categoryId));
      }
    }

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
        fetchEbooks();
      } else {
        log('Failed to delete ebook.');
      }
    } catch (error) {
      log('Error deleting ebook: $error');
    }
  }
}
