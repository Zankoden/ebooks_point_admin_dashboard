import 'package:ebooks_point_admin/dashboard.dart';
import 'package:ebooks_point_admin/pages/ebooks/test/explore_page.dart';
import 'package:ebooks_point_admin/pages/ebooks/view/view_author_ebooks.dart';
import 'package:ebooks_point_admin/pages/upload_ebooks/updated_upload_ebooks.dart';

import 'package:ebooks_point_admin/pages/view_users/view_users_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String homePage = '/';
  static const String viewAllUsersPage = '/viewAllUsersPage';
  static const String profilePage = '/profile';
  static const String uploadEbookPage = '/uploadEbook';
  static const String viewEbookPage = '/viewEbook';
  static const String settingsPage = '/settings';
  static const String history = '/history';
  static const String signout = '/signout';
  // static const String viewAllUsers = '/viewAllUsers';
  static const String viewAllEbooks = '/viewAllEbooks';
  static const String viewAuthorAllEbooks = '/viewAuthorAllEbooks';
}

List<GetPage<dynamic>> get appPageRoute {
  return [
    GetPage(
      name: AppRoutes.homePage,
      page: () => const DashBoardPage(),
    ),
    GetPage(
      name: AppRoutes.viewAllUsersPage,
      page: () => ViewAllUsersPage(),
    ),
    
    GetPage(
      name: AppRoutes.uploadEbookPage,
      page: () => EbookUploadPage(),
    ),
    GetPage(
      name: AppRoutes.viewAllEbooks,
      // page: () => ViewAllEbooksPage(),
      page: () => ExplorePage(),
    ),
   
  
    GetPage(
      name: AppRoutes.viewAllUsersPage,
      page: () => ViewAllUsersPage(),
    ),
    GetPage(
      name: AppRoutes.viewAuthorAllEbooks,
      // page: () => ViewAllEbooksPage(),
      page: () => ViewAuthorEbooks(),
      // page: () => TestPage(),
    ),
  ];
}
