import 'dart:convert';
import 'dart:developer';

import 'package:ebooks_point_admin/api/api_services.dart';
import 'package:ebooks_point_admin/model/category_model.dart';
import 'package:ebooks_point_admin/model/ebook_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:ebooks_point_admin/widgets/custom_card.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LineChartCardController extends GetxController {
  RxList<Ebook> books = <Ebook>[].obs;

  RxList<Category> categories = <Category>[].obs;

  Map<String, int> monthlyUploads = {};

  @override
  void onInit() {
    super.onInit();
    getBooks();
    getCategories();
    calculateMonthlyUploads();
  }

  Future<List<Ebook>> fetchEbooks() async {
    try {
      var response = await http.get(Uri.parse(APIService.fetchEbooksURL));

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
    } catch (e) {
      log("Log for getBooks catch: $e");
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
      log("Log for getCategories catch: $e");
    }
  }

  Future<void> calculateMonthlyUploads() async {
    try {
      List<Ebook> allBooks = await fetchEbooks();

      monthlyUploads = {
        'Jan': 0,
        'Feb': 0,
        'Mar': 0,
        'Apr': 0,
        'May': 0,
        'Jun': 0,
        'Jul': 0,
        'Aug': 0,
        'Sep': 0,
        'Oct': 0,
        'Nov': 0,
        'Dec': 0,
      };

      for (var book in allBooks) {
        if (book.uploadedDate != null) {
          String month = book.uploadedDate!.split('-')[1];
          monthlyUploads[month] = monthlyUploads[month]! + 1;
          log("The monthlyUploads: $monthlyUploads");
        }
      }

      update();
    } catch (e) {
      log("Log for calculateMonthlyUploads catch: $e");
    }
  }

  late List<FlSpot> spots = monthlyUploads.entries.map(
    (entry) {
      String month = entry.key;
      int uploads = entry.value;
      int monthIndex = DateTime.parse("2024-$month-01").month;
      return FlSpot(monthIndex.toDouble(), uploads.toDouble());
    },
  ).toList();
}

class LineChartCard extends StatelessWidget {
  LineChartCard({super.key});

  final c = Get.put(LineChartCardController());

  final List<FlSpot> spots = const [
    FlSpot(1.68, 21.04),
    FlSpot(2.84, 26.23),
    FlSpot(5.19, 19.82),
    FlSpot(6.01, 24.49),
    FlSpot(7.81, 19.82),
    FlSpot(9.49, 23.50),
    FlSpot(12.26, 19.57),
    FlSpot(15.63, 20.90),
    FlSpot(20.39, 39.20),
    FlSpot(23.69, 75.62),
    FlSpot(26.21, 46.58),
    FlSpot(29.87, 42.97),
    FlSpot(32.49, 46.54),
    FlSpot(35.09, 40.72),
    FlSpot(38.74, 43.18),
    FlSpot(41.47, 59.91),
    FlSpot(43.12, 53.18),
    FlSpot(46.30, 90.10),
    FlSpot(47.88, 81.59),
    FlSpot(51.71, 75.53),
    FlSpot(54.21, 78.95),
    FlSpot(55.23, 86.94),
    FlSpot(57.40, 78.98),
    FlSpot(60.49, 74.38),
    FlSpot(64.30, 48.34),
    FlSpot(67.17, 70.74),
    FlSpot(70.35, 75.43),
    FlSpot(73.39, 69.88),
    FlSpot(75.87, 80.04),
    FlSpot(77.32, 74.38),
    FlSpot(81.43, 68.43),
    FlSpot(86.12, 69.45),
    FlSpot(90.06, 78.60),
    FlSpot(94.68, 46.05),
    FlSpot(98.35, 42.80),
    FlSpot(101.25, 53.05),
    FlSpot(103.07, 46.06),
    FlSpot(106.65, 42.31),
    FlSpot(108.20, 32.64),
    FlSpot(110.40, 45.14),
    FlSpot(114.24, 53.27),
    FlSpot(116.60, 42.13),
    FlSpot(118.52, 57.60),
  ];

  final leftTitle = {
    0: '0',
    20: '2K',
    40: '4K',
    60: '6K',
    80: '8K',
    100: '10K'
  };
  final bottomTitle = {
    0: 'Jan',
    10: 'Feb',
    20: 'Mar',
    30: 'Apr',
    40: 'May',
    50: 'Jun',
    60: 'Jul',
    70: 'Aug',
    80: 'Sep',
    90: 'Oct',
    100: 'Nov',
    110: 'Dec',
  };

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Steps Overview",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 20,
          ),
          AspectRatio(
            aspectRatio: Responsive.isMobile(context) ? 9 / 4 : 16 / 6,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(
                  handleBuiltInTouches: true,
                ),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return bottomTitle[value.toInt()] != null
                            ? SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 10,
                                child: Text(
                                    bottomTitle[value.toInt()].toString(),
                                    style: TextStyle(
                                        fontSize: Responsive.isMobile(context)
                                            ? 9
                                            : 12,
                                        color: Colors.grey[400])),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return leftTitle[value.toInt()] != null
                            ? Text(leftTitle[value.toInt()].toString(),
                                style: TextStyle(
                                    fontSize:
                                        Responsive.isMobile(context) ? 9 : 12,
                                    color: Colors.grey[400]))
                            : const SizedBox();
                      },
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                      isCurved: true,
                      curveSmoothness: 0,
                      color: Theme.of(context).primaryColor,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.5),
                            Colors.transparent
                          ],
                        ),
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      dotData: const FlDotData(show: false),
                      spots: spots)
                ],
                minX: 0,
                maxX: 120,
                maxY: 105,
                minY: -5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
