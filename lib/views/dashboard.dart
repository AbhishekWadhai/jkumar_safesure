import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/colors.dart';

import 'package:sure_safe/controllers/home_controller.dart';
import 'package:sure_safe/controllers/safety_report_controller.dart';
import 'package:sure_safe/helpers/sixed_boxes.dart';
import 'package:sure_safe/widgets/new_bar_chart.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key, required this.homeController});
  final HomeController homeController;
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SafetyReportChartController safetyReportController1 =
      Get.put(SafetyReportChartController());

  late PageController _pageController;
  int _currentPage = 0;
  List<Widget> charts = [];
  String selectedFilter = "Recent";
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 1.0,
    );
    updateCharts();
  }

  /// Creates a list of chart instances dynamically
  List<Widget> getCharts({bool showLegend = false}) {
    return [
      DynamicChart(
        data: safetyReportController1.avgManPowers,
        title: "Avg. Manpower",
        legendName: "Manpower",
        showLegend: showLegend,
        chartType: ChartType.column,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        data: safetyReportController1.totalManHoursWorkedinM,
        title: "Avg. Manhours Worked",
        legendName: "Avg. Manhours Worked",
        showLegend: showLegend,
        chartType: ChartType.column,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        data: safetyReportController1.safetyTraining,
        title: "Safety Training Target(%)",
        legendName: "Percentages of Trainees",
        showLegend: showLegend,
        chartType: ChartType.doughnut,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        title: "Frequency Rate(FR) and Severity Rate(SR)",
        groupedData: [
          safetyReportController1.fr,
          safetyReportController1.sr,
        ],
        legendNames: const [
          "FR",
          "SR",
        ],
        showLegend: showLegend,
        chartType: ChartType.groupedColumn,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        data: safetyReportController1.uaucResolved,
        title: "UAUC Rectified(%)",
        legendName: "UAUC",
        showLegend: showLegend,
        chartType: ChartType.bar,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        data: safetyReportController1.safetyInduction,
        title: "No. of Persons Safety Inducted",
        legendName: "Training Hours",
        showLegend: showLegend,
        chartType: ChartType.bar,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        data: safetyReportController1.safetyCommitteeMeetings,
        title: "Safety Committee Meetings",
        legendName: "Training Hours",
        showLegend: showLegend,
        chartType: ChartType.column,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        title: "Safety Audit",
        groupedData: [
          safetyReportController1.externalAudits,
          safetyReportController1.internalAudits,
        ],
        legendNames: const ["External", "Internal"],
        showLegend: showLegend,
        chartType: ChartType.groupedColumn,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        title: "Non-Injury Incident",
        groupedData: [
          safetyReportController1.majorEnvironmentalCases,
          safetyReportController1.animalAndInsectBiteCases,
          safetyReportController1.dangerousOccurrences,
          safetyReportController1.nearMissIncidents,
          safetyReportController1.fireCases,
        ],
        legendNames: const [
          "Environmental Incident",
          "Animal or InsectBiteCases",
          "Dangerous Occurrences",
          "Near Miss",
          "Fire",
        ],
        showLegend: showLegend,
        chartType: ChartType.groupedColumn,
        textColor: Colors.white,
        titleColor: Colors.white,
      ),
      DynamicChart(
        title: "Injury Incident",
        groupedData: [
          safetyReportController1.fatality,
          safetyReportController1.ltiCases,
          safetyReportController1.mtiCases,
          safetyReportController1.fac
        ],
        legendNames: const ["Fatal", "LTI", "MTI", "FAC"],
        showLegend: showLegend,
        chartType: ChartType.groupedColumn,
        textColor: Colors.white,
        titleColor: Colors.white,
      )
    ];
  }

  /// Updates the chart list for the main view
  void updateCharts() {
    setState(() {
      charts = getCharts();
    });
  }

  /// Shows a full-screen dialog with a newly created chart (with legend)

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index % charts.length;
          });
        },
        itemBuilder: (context, index) {
          final chartIndex = index % charts.length;

          return GestureDetector(
            onTap: () => widget.homeController
                .changeTabIndex(0), // Navigate to Dashboard

            //  _showFullScreenChart(
            //   chartIndex,
            //   context,
            //   safetyReportController1,
            //   getCharts,
            //   selectedFilter,
            //   (newFilter) {
            //     // Add this callback
            //     setState(() {
            //       selectedFilter = newFilter;
            //       updateCharts(); // Update charts when filter changes
            //     });
            //   },
            // ), // Open full-screen chart
            child: AnimatedScale(
              scale: _currentPage == chartIndex ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: charts[chartIndex]),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            "$selectedFilter observations",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.more_horiz_rounded,
                                color: Colors.black,
                              ))
                        ],
                      ),
                    ),
                    sb8
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void _showFullScreenChart(
  int chartIndex,
  BuildContext context,
  SafetyReportChartController safetyReportController,
  Function({bool showLegend}) getCharts,
  String selectedFilter,
  Function(String) onFilterChanged, // Add this callback
) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          List<Widget> charts = getCharts(showLegend: true);

          return Dialog(
            insetPadding: EdgeInsets.all(8.0),
            backgroundColor: AppColors.appMainMid,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.appMainDark),
                  value: selectedFilter,
                  onChanged: (filter) {
                    if (filter != null) {
                      setDialogState(() {
                        selectedFilter = filter;
                        onFilterChanged(
                            filter); // Call the callback to update the state in DashboardPage3
                        safetyReportController.updateDataForFilter(filter);
                      });
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                    DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                    DropdownMenuItem(
                        value: "Quarterly", child: Text("Quarterly")),
                    DropdownMenuItem(value: "Yearly", child: Text("Yearly")),
                    DropdownMenuItem(value: "Recent", child: Text("Recent")),
                  ],
                ),
                FutureBuilder<void>(
                  future: Future.microtask(() {
                    safetyReportController.updateDataForFilter(selectedFilter);
                  }),
                  builder: (context, snapshot) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: charts[chartIndex],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
