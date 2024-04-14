import 'package:ebooks_point_admin/dashboard.dart';
import 'package:ebooks_point_admin/pages/upload_ebooks/updated_upload_ebooks.dart';
import 'package:ebooks_point_admin/pages/view_users/view_users_page.dart';
import 'package:flutter/material.dart';

class URLAppRoutes {
  static final routes = <String, WidgetBuilder>{
    '/': (context) => const DashBoardPage(),
   
    '/uploadEbook': (context) => EbookUploadPage(),
    // '/viewAllEbooks': (context) => ViewAllEbooksPage(),

    '/viewAllUsers': (context) => ViewAllUsersPage(),
  };
}
