import 'dart:convert';
import 'package:http/http.dart' as http;

// Model class for displaying ebooks
// class Ebook {
//   final String title;
//   final String description;
//   final String pdfUrl;
//   final String thumbnailUrl;
//   final int ebookId;

//   Ebook({
//     required this.title,
//     required this.description,
//     required this.pdfUrl,
//     required this.thumbnailUrl,
//     required this.ebookId,
//   });
// }

class APIService {
  static const String baseURL =
      'http://127.0.0.1/ebooks_point'; // Base URL of your API

  // static const String baseURL =
  //     'http://127.0.0.1/database_test_ebooks'; // Base URL of your API

  // static const String baseURL =
  //     'http://10.0.2.2/database_test_ebooks'; // Base URL of your API

  /// Login API
  static Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    const String url =
        '$baseURL/login.php'; // Construct the complete URL for login API

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Decode JSON response
    } else {
      throw Exception('Failed to login'); // Throw exception in case of failure
    }
  }

  /// Register api
  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required bool isAuthor,
  }) async {
    const String url =
        '$baseURL/register.php'; // Construct the complete URL for register API

    final response = await http.post(
      Uri.parse(url),
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'is_author': isAuthor ? '1' : '0', // Convert boolean to integer
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Decode JSON response
    } else {
      throw Exception(
          'Failed to register'); // Throw exception in case of failure
    }
  }

  /// Display books api
  // static Future<List<Ebook>> fetchEbooks() async {
  //   try {
  //     var response =
  //         await http.get(Uri.parse('${APIService.baseURL}/fetch_ebooks.php'));
  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);
  //       if (jsonData is List) {
  //         return jsonData
  //             .map((ebook) => Ebook(
  //                   title: ebook['title'],
  //                   description: ebook['description'],
  //                   pdfUrl: '${APIService.baseURL}/${ebook['pdf_url']}',
  //                   thumbnailUrl:
  //                       '${APIService.baseURL}/${ebook['thumbnail_url']}',
  //                   ebookId: ebook['ebook_id'] as int,
  //                 ))
  //             .toList();
  //       } else if (jsonData is Map) {
  //         // If the response is a single ebook
  //         return [
  //           Ebook(
  //             title: jsonData['title'],
  //             description: jsonData['description'],
  //             pdfUrl: '${APIService.baseURL}/${jsonData['pdf_url']}',
  //             thumbnailUrl:
  //                 '${APIService.baseURL}/${jsonData['thumbnail_url']}',
  //             ebookId: jsonData['ebook_id'] as int,
  //           )
  //         ];
  //       } else {
  //         throw Exception('Invalid response format');
  //       }
  //     } else {
  //       throw Exception('Failed to load ebooks');
  //     }
  //   } catch (e) {
  //     log('Error fetching ebooks: $e');
  //     throw Exception('Failed to load ebooks');
  //   }
  // }

  static const String viewAllUsersURL = "$baseURL/fetch_all_users.php";
  static const String deleteUserURL = "$baseURL/admin/delete_user.php";
  static const String fetchAuthorEbooksURL =
      "$baseURL/admin/fetch_author_ebooks.php";
  static const String deleteEbooksURL = "$baseURL/admin/delete_ebooks.php";
  static const String editEbooksURL = "$baseURL/admin/edit_ebooks.php";
  static const String fetchEbookByIdURL = "$baseURL/admin/get_ebook_by_id.php";
  static const String updateUserInfoURL = "$baseURL/admin/update_user_info.php";

  ///Test
  ///
  static const String loginURL = '$baseURL/login.php';
  static const String fetchEbooksURL = '$baseURL/fetch_ebooks.php';
  static const String fetchCategories = '$baseURL/fetch_categories.php';
    static const String getUserInfo = '$baseURL/get_user_info.php';

}
