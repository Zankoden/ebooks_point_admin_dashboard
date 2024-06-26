import 'package:ebooks_point_admin/dash_board_screen.dart';
import 'package:ebooks_point_admin/pages/upload_ebooks/updated_upload_ebooks.dart';
import 'package:ebooks_point_admin/pages/view_users/view_users_page.dart';
import 'package:flutter/material.dart';

class URLAppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const DashBoardPage(),
    '/uploadEbook': (context) => EbookUploadPage(),
    '/viewAllUsers': (context) => ViewAllUsersPage(),
  };
}
