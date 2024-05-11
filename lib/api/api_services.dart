class APIService {
  //test database url
  static const String baseURL =
      'http://127.0.0.1/ebooks_point_v2'; // Base URL of your API

  //actual test url
  // static const String baseURL =
  //     'http://127.0.0.1/ebooks_point'; // Base URL of your API

  // static const String baseURL =
  //     'http://127.0.0.1/database_test_ebooks'; // Base URL of your API

  // static const String baseURL =
  //     'http://10.0.2.2/database_test_ebooks'; // Base URL of your API

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
