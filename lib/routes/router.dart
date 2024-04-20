import 'package:ebooks_point_admin/dash_board_screen.dart';
import 'package:ebooks_point_admin/pages/ebooks/views/admin/explore_page.dart';
import 'package:ebooks_point_admin/pages/ebooks/views/author/view_author_ebooks.dart';
import 'package:ebooks_point_admin/pages/upload_ebooks/updated_upload_ebooks.dart';

import 'package:ebooks_point_admin/pages/view_users/view_users_page.dart';
import 'package:ebooks_point_admin/splash_screen/views/splash_screen_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splashScreenPage = '/';
  static const String homePage = '/homePage';
  static const String viewAllUsersPage = '/viewAllUsersPage';
  static const String profilePage = '/profile';
  static const String uploadEbookPage = '/uploadEbook';
  static const String viewEbookPage = '/viewEbook';
  static const String settingsPage = '/settings';
  static const String history = '/history';
  static const String signout = '/signout';

  static const String viewAllEbooks = '/viewAllEbooks';
  static const String viewAuthorAllEbooks = '/viewAuthorAllEbooks';
}

List<GetPage<dynamic>> get appPageRoute {
  return [
    GetPage(
      name: AppRoutes.splashScreenPage,
      page: () => SplashScreenPage(),
    ),
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
      page: () => ExplorePage(),
    ),
    GetPage(
      name: AppRoutes.viewAllUsersPage,
      page: () => ViewAllUsersPage(),
    ),
    GetPage(
      name: AppRoutes.viewAuthorAllEbooks,
      page: () => ViewAuthorEbooks(),
    ),
  ];
}
