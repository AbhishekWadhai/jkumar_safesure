import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/safety_report_controller.dart';
import 'package:sure_safe/widgets/new_bar_chart.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final SafetyReportChartController safetyReportController1 =
      Get.put(SafetyReportChartController());

  late PageController _pageController;
  int _currentPage = 0;
  List<Widget> charts = [];
  String selectedFilter = "Recent";
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1000,
      viewportFraction: 1.0,
    );
    updateCharts();
    weeks = safetyReportController1
        .getWeeksOfYear(int.parse(safetyReportController1.selectedYear.value));
  }

  final List<String> filters = [
    "Weekly",
    "Monthly",
    "Quarterly",
    "Yearly",
    "Recent"
  ];
  int selectedYear = DateTime.now().year;
  int? selectedQuarter;
  int? selectedMonth;

  final List<int> years = List.generate(5, (i) => DateTime.now().year - i);
  final List<String> quarters = [
    "Quarter 1",
    "Quarter 2",
    "Quarter 3",
    "Quarter 4"
  ];
  final Map<String, int> monthMap = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };
  List<Map<String, dynamic>> weeks = [];

  /// Creates a list of chart instances dynamically
  List<Widget> getCharts({bool showLegend = false}) {
    return [
      DynamicChart(
        data: safetyReportController1.avgManPowers,
        title: "Avg. Manpower",
        legendName: "Manpower",
        showLegend: true,
        chartType: ChartType.column,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.totalManHoursWorkedinM,
        title: "Avg. Manhours Worked(Per 1000 hrs)",
        legendName: "Avg. Manhours Worked",
        showLegend: true,
        chartType: ChartType.column,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.safetyTraining,
        title: "Safety Training Target(%)",
        legendName: "Percentages of Trainees",
        showLegend: true,
        chartType: ChartType.doughnut,
        textColor: Colors.black,
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
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.uaucResolved,
        title: "UAUC Rectified(%)",
        legendName: "UAUC",
        showLegend: true,
        chartType: ChartType.bar,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.safetyInduction,
        title: "No. of Persons Safety Inducted",
        legendName: "Training Hours",
        showLegend: true,
        chartType: ChartType.column,
        textColor: Colors.black,
      ),
      DynamicChart(
        data: safetyReportController1.safetyCommitteeMeetings,
        title: "Safety Committee Meetings",
        legendName: "Training Hours",
        showLegend: true,
        chartType: ChartType.column,
        textColor: Colors.black,
      ),
      DynamicChart(
        title: "Safety Audit",
        groupedData: [
          safetyReportController1.externalAudits,
          safetyReportController1.internalAudits,
        ],
        legendNames: const ["External", "Internal"],
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
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
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
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
        showLegend: true,
        chartType: ChartType.groupedColumn,
        textColor: Colors.black,
      )
    ];
  }

  /// Updates the chart list for the main view
  void updateCharts() {
    setState(() {
      charts = getCharts();
    });
  }

  final _labelStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  final _dropdownDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );

  /// Shows a full-screen dialog with a newly created chart (with legend)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              safetyReportController1.updateDataForFilter("Recent");
              updateCharts();
            },
          ),
          IconButton(
            onPressed: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    constraints:
                        BoxConstraints(maxHeight: 600), // Prevent overflow
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "📊 Filter Options",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Divider(thickness: 1.2, height: 24),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Year Dropdown
                                Text("Select Year:", style: _labelStyle),
                                const SizedBox(height: 8),
                                Obx(
                                  () => DropdownButtonFormField<int>(
                                    decoration: _dropdownDecoration,
                                    value: int.parse(safetyReportController1
                                        .selectedYear.value),
                                    items: years.map((year) {
                                      return DropdownMenuItem<int>(
                                        value: year,
                                        child: Text(year.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (year) {
                                      setState(() {
                                        weeks = safetyReportController1
                                            .getWeeksOfYear(year!);
                                        safetyReportController1.selectedYear
                                            .value = year.toString();
                                        safetyReportController1
                                            .updateDataForFilter("Yearly");
                                        updateCharts();
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// Quarter Dropdown
                                Text("Select Quarter:", style: _labelStyle),
                                const SizedBox(height: 8),
                                Obx(
                                  () => DropdownButtonFormField<String>(
                                    decoration: _dropdownDecoration,
                                    value: safetyReportController1
                                        .selectedQuarter.value,
                                    items: quarters.map((quarter) {
                                      return DropdownMenuItem<String>(
                                        value: quarter,
                                        child: Text(quarter),
                                      );
                                    }).toList(),
                                    onChanged: (quarter) {
                                      setState(() {
                                        safetyReportController1
                                            .selectedQuarter.value = quarter!;
                                        safetyReportController1
                                            .updateDataForFilter("Quarterly");
                                        updateCharts();
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// Month Dropdown
                                Text("Select Month:", style: _labelStyle),
                                const SizedBox(height: 8),
                                Obx(
                                  () => DropdownButtonFormField<String>(
                                    decoration: _dropdownDecoration,
                                    value: safetyReportController1
                                        .selectedMonth.value
                                        .toString(),
                                    items: monthMap.entries.map((entry) {
                                      return DropdownMenuItem<String>(
                                        value: entry.value.toString(),
                                        child: Text(entry.key),
                                      );
                                    }).toList(),
                                    onChanged: (month) {
                                      setState(() {
                                        safetyReportController1.selectedMonth
                                            .value = int.parse(month!);
                                        safetyReportController1
                                            .updateDataForFilter("Monthly");
                                        updateCharts();
                                      });
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// Week Dropdown
                                Text("Select Week:", style: _labelStyle),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<Map<String, dynamic>>(
                                  decoration: _dropdownDecoration,
                                  value: safetyReportController1.selectedWeek,
                                  hint: const Text('Select Week'),
                                  onChanged: (value) {
                                    setState(() {
                                      safetyReportController1
                                          .selectedWeek?.value = value ?? {};
                                      safetyReportController1
                                          .updateDataForFilter("Weekly");
                                    });
                                  },
                                  items: weeks.map((week) {
                                    return DropdownMenuItem<
                                        Map<String, dynamic>>(
                                      value: week,
                                      child: Text(week['label']),
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 20),

                                /// Date Range Picker
                                Text("Select Date Range:", style: _labelStyle),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => showDateRangeDialog(context),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      safetyReportController1.startDate !=
                                                  null &&
                                              safetyReportController1.endDate !=
                                                  null
                                          ? "${formatDate(safetyReportController1.startDate!)} - ${formatDate(safetyReportController1.endDate!)}"
                                          : "Pick Date Range",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: charts.length,
        itemBuilder: (context, index) {
          final chartIndex = index;

          return SizedBox(
            height: 300,
            child: GestureDetector(
              onTap: () => _showFullScreenChart(
                chartIndex,
                context,
                safetyReportController1,
                getCharts,
                selectedFilter,
                (newFilter) {
                  // Add this callback
                  setState(() {
                    selectedFilter = newFilter;
                    updateCharts(); // Update charts when filter changes
                  });
                },
              ), // Open full-screen chart
              child: AnimatedScale(
                scale: _currentPage == chartIndex ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: charts[chartIndex], // Keep your chart inside
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Text(
                              "$selectedFilter observations",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey.shade200,
                              child: const Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showDateRangeDialog(
    BuildContext context,
  ) {
    DateTime? tempStart = safetyReportController1.startDate;
    DateTime? tempEnd = safetyReportController1.endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Select Date Range"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Start Date"),
                  subtitle: Text(tempStart != null
                      ? "${tempStart!.toLocal()}".split(' ')[0]
                      : "Select start date"),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: tempStart ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        tempStart = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text("End Date"),
                  subtitle: Text(tempEnd != null
                      ? "${tempEnd!.toLocal()}".split(' ')[0]
                      : "Select end date"),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: tempEnd ?? DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        tempEnd = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    safetyReportController1.startDate = null;
                    safetyReportController1.endDate = null;
                    tempStart = null;
                    tempEnd = null;
                  });
                },
                child: const Text("Clear", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cancel
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (tempStart != null && tempEnd != null) {
                    safetyReportController1.startDate = tempStart;
                    safetyReportController1.endDate = tempEnd;
                    safetyReportController1.updateDataForCustomDateRange(
                        tempStart!, tempEnd!);
                    updateCharts();
                  }
                  Navigator.pop(context);
                },
                child: const Text("Apply"),
              ),
            ],
          );
        });
      },
    );
  }
}

void _showFullScreenChart(
  int chartIndex,
  BuildContext context,
  SafetyReportChartController safetyReportController1,
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
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 600,
              width: double.infinity, // optional, make it wide
              child: Column(
                children: [
                  Expanded(
                    // This allows chart to take full height inside SizedBox
                    child: FutureBuilder<void>(
                      future: Future.microtask(() {
                        safetyReportController1
                            .updateDataForFilter(selectedFilter);
                      }),
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: charts[chartIndex],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
