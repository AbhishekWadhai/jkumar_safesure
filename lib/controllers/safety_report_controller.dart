import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/model/safety_report_model.dart';
import 'package:sure_safe/services/formatters.dart';
import 'package:sure_safe/widgets/new_bar_chart.dart';

class SafetyReportChartController extends GetxController {
  RxList<SafetyReportModel> safetyReportData = <SafetyReportModel>[].obs;
  RxList<SafetyReportModel> ltiCasesData = <SafetyReportModel>[].obs;
  RxList<ChartData> safetyManHoursWorked = <ChartData>[].obs;
  RxList<ChartData> avgManPowers = <ChartData>[].obs;
  RxList<ChartData> tbtMeeting = <ChartData>[].obs;
  RxList<ChartData> safetyTraining = <ChartData>[].obs;
  RxList<ChartData> uaucResolved = <ChartData>[].obs;
  RxList<ChartData> safetyInduction = <ChartData>[].obs;
  RxList<ChartData> specificTraining = <ChartData>[].obs;

  RxList<ChartData> totalManHoursWorked = <ChartData>[].obs;
  RxList<ChartData> fatality = <ChartData>[].obs;
  RxList<ChartData> ltiCases = <ChartData>[].obs;
  RxList<ChartData> mtiCases = <ChartData>[].obs;
  RxList<ChartData> fac = <ChartData>[].obs;
  RxList<ChartData> majorEnvironmentalCases = <ChartData>[].obs;
  RxList<ChartData> animalAndInsectBiteCases = <ChartData>[].obs;
  RxList<ChartData> dangerousOccurrences = <ChartData>[].obs;
  RxList<ChartData> nearMissIncidents = <ChartData>[].obs;
  RxList<ChartData> fireCases = <ChartData>[].obs;
  RxList<ChartData> manDaysLost = <ChartData>[].obs;
  RxList<ChartData> fr = <ChartData>[].obs;
  RxList<ChartData> sr = <ChartData>[].obs;
  RxList<ChartData> safeLtiFreeDays = <ChartData>[].obs;
  RxList<ChartData> safeLtiFreeManHours = <ChartData>[].obs;
  RxList<ChartData> ncrPenaltyWarnings = <ChartData>[].obs;
  RxList<ChartData> suggestionsReceived = <ChartData>[].obs;
  RxList<ChartData> uaUcReportedClosed = <ChartData>[].obs;
  RxList<ChartData> tbtMeetingHours = <ChartData>[].obs;
  RxList<ChartData> personsSafetyInducted = <ChartData>[].obs;
  RxList<ChartData> specificSafetyTrainingHours = <ChartData>[].obs;
  RxList<ChartData> totalTrainingHours = <ChartData>[].obs;
  RxList<ChartData> safetyItemsInspections = <ChartData>[].obs;
  RxList<ChartData> safetyCommitteeMeetings = <ChartData>[].obs;
  RxList<ChartData> internalAudits = <ChartData>[].obs;
  RxList<ChartData> externalAudits = <ChartData>[].obs;
  RxList<ChartData> awardsAndAppreciations = <ChartData>[].obs;
  RxList<ChartData> safetyAwardRatingHighest = <ChartData>[].obs;
  RxList<ChartData> safetyAwardRatingLowest = <ChartData>[].obs;
  RxList<ChartData> totalManHoursWorkedinM = <ChartData>[].obs;

  bool isOpen = false;
  int openedChart = 0;
  String selectedProject = "All";
  RxString selectedYear = "2025".obs;
  RxString selectedQuarter = "Quarter 1".obs;
  RxInt selectedMonth = 1.obs;
  DateTime? startDate;
  DateTime? endDate;

  //RxString selectedWeek = ''.obs;
  RxMap<String, dynamic>? selectedWeek;

  @override
  void onInit() {
    super.onInit();
    print("🔍 Raw safety report data from Strings.safetyreport:");
    print(Strings.safetyreport.length);

    safetyReportData.value = Strings.safetyreport.map((e) {
      print("📄 Mapping JSON to SafetyReportModel: $e");
      final model = SafetyReportModel.fromJson(e);
      print("✅ Created model: $model");
      return model;
    }).toList()
      ..sort((a, b) {
        print("📊 Comparing ${a.createdAt} with ${b.createdAt}");
        return a.createdAt.compareTo(b.createdAt);
      });

    print("📌 Final sorted list:");
    for (var report in safetyReportData.value) {
      print("• ${report.createdAt} → $report");
    }

    _populateChartData();
    getLticases();
  }

  List<Map<String, dynamic>> getWeeksOfYear(int year) {
    List<Map<String, dynamic>> weeks = [];

    DateTime current = DateTime(year, 1, 1);
    DateTime endOfYear = DateTime(year, 12, 31);
    DateFormat formatter = DateFormat('dd MMM');

    int weekNumber = 1;

    // First week: Jan 1 to the first Sunday
    DateTime endOfWeek = current.add(Duration(days: 7 - current.weekday));
    if (endOfWeek.isAfter(endOfYear)) endOfWeek = endOfYear;

    weeks.add({
      'week': weekNumber++,
      'start': current,
      'end': endOfWeek,
      'label':
          'Week 1 (${formatter.format(current)} - ${formatter.format(endOfWeek)})'
    });

    current = endOfWeek.add(Duration(days: 1));

    // Following weeks: Monday to Sunday
    while (current.isBefore(endOfYear)) {
      DateTime startOfWeek = current;
      endOfWeek = startOfWeek.add(Duration(days: 6));
      if (endOfWeek.isAfter(endOfYear)) endOfWeek = endOfYear;

      weeks.add({
        'week': weekNumber,
        'start': startOfWeek,
        'end': endOfWeek,
        'label':
            'Week $weekNumber (${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)})'
      });

      weekNumber++;
      current = endOfWeek.add(Duration(days: 1));
    }

    return weeks;
  }

  getLticases() {
    ltiCasesData.value = safetyReportData.where((e) {
      return e.ltiCases > 0;
    }).toList();
    print("----------------------------------------------");
  }

  void _populateChartData() {
    List<SafetyReportModel> safetyReportData = filterLatestEntries(7);
    _updateChartData(safetyReportData);
  }

  double roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }
  // Inside SafetyReportController class

// Method to get sums filtered by project name
  Map<String, double> getSummedData({String? projectId}) {
    // Filter data if project ID is provided (and not "All")
    List<SafetyReportModel> filteredData =
        projectId == null || projectId == "All"
            ? safetyReportData
            : safetyReportData
                .where((report) => report.project.id == projectId)
                .toList();

    // Calculate sums for all metrics
    return {
      'avgManPowers': filteredData.fold(
          0.0, (sum, report) => sum + report.totalAvgManpower),
      'tbtMeeting': double.parse((filteredData
          .fold<double>(
              0.0,
              (double sum, SafetyReportModel report) =>
                  sum + (report.tbtMeetingHours ?? 0.0))
          .toStringAsFixed(2))),
      'safetyTraining': filteredData.fold(
          0.0, (sum, report) => sum + report.totalTrainingHours),
      'uaucResolved': filteredData.fold(
          0.0, (sum, report) => sum + report.uaUcReportedClosed),
      'totalManHoursWorked': filteredData.fold(
          0.0, (sum, report) => sum + report.totalManHoursWorked),
      'fatality':
          filteredData.fold(0.0, (sum, report) => sum + report.fatality),
      'ltiCases':
          filteredData.fold(0.0, (sum, report) => sum + report.ltiCases),
      'mtiCases':
          filteredData.fold(0.0, (sum, report) => sum + report.mtiCases),
      'fac': filteredData.fold(0.0, (sum, report) => sum + report.fac),
      'majorEnvironmentalCases': filteredData.fold(
          0.0, (sum, report) => sum + report.majorEnvironmentalCases),
      'animalAndInsectBiteCases': filteredData.fold(
          0.0, (sum, report) => sum + report.animalAndInsectBiteCases),
      'dangerousOccurrences': filteredData.fold(
          0.0, (sum, report) => sum + report.dangerousOccurrences),
      'nearMissIncidents': filteredData.fold(
          0.0, (sum, report) => sum + report.nearMissIncidents),
      'fireCases':
          filteredData.fold(0.0, (sum, report) => sum + report.fireCases),
      'manDaysLost':
          filteredData.fold(0.0, (sum, report) => sum + report.manDaysLost),
      'fr': filteredData.fold(0.0, (sum, report) => sum + report.fr),
      'sr': filteredData.fold(0.0, (sum, report) => sum + report.sr),
      'safeLtiFreeDays':
          filteredData.fold(0.0, (sum, report) => sum + report.safeLtiFreeDays),
      'safeLtiFreeManHours': filteredData.fold(
          0.0, (sum, report) => sum + report.safeLtiFreeManHours),
      'ncrPenaltyWarnings': filteredData.fold(
          0.0, (sum, report) => sum + report.ncrPenaltyWarnings),
      'suggestionsReceived': filteredData.fold(
          0.0, (sum, report) => sum + report.suggestionsReceived),
      'safetyInduction': filteredData.fold(
          0.0, (sum, report) => sum + report.personsSafetyInducted),
      'specificTraining': filteredData.fold(
          0.0, (sum, report) => sum + report.specificSafetyTrainingHours),
      'safetyItemsInspections': filteredData.fold(
          0.0, (sum, report) => sum + report.safetyItemsInspections),
      'safetyCommitteeMeetings': filteredData.fold(
          0.0, (sum, report) => sum + report.safetyCommitteeMeetings),
      'internalAudits':
          filteredData.fold(0.0, (sum, report) => sum + report.internalAudits),
      'externalAudits':
          filteredData.fold(0.0, (sum, report) => sum + report.externalAudits),
      'awardsAndAppreciations': filteredData.fold(
          0.0, (sum, report) => sum + report.awardsAndAppreciations),
      'safetyAwardRatingHighest': filteredData.fold(
          0.0, (sum, report) => sum + report.safetyAwardRatingHighest),
      'safetyAwardRatingLowest': filteredData.fold(
          0.0, (sum, report) => sum + report.safetyAwardRatingLowest),
      'totalManHoursWorkedinM': filteredData.fold(
          0.0, (sum, report) => sum + report.totalManHoursWorked),
    };
  }

  void _updateChartData(List<SafetyReportModel> data) {
    avgManPowers.value =
        _aggregateData(data, (report) => report.totalAvgManpower.toDouble());
    tbtMeeting.value =
        _aggregateData(data, (report) => report.tbtMeetingHours.toDouble());

    uaucResolved.value =
        _aggregateData(data, (report) => report.uaUcReportedClosed.toDouble());
    safetyInduction.value = _aggregateData(
        data, (report) => report.personsSafetyInducted.toDouble());
    specificTraining.value = _aggregateData(
        data, (report) => report.specificSafetyTrainingHours.toDouble());

    totalManHoursWorked.value =
        _aggregateData(data, (report) => report.totalManHoursWorked.toDouble());

    fatality.value =
        _aggregateData(data, (report) => report.fatality.toDouble());
    ltiCases.value =
        _aggregateData(data, (report) => report.ltiCases.toDouble());
    mtiCases.value =
        _aggregateData(data, (report) => report.mtiCases.toDouble());
    fac.value = _aggregateData(data, (report) => report.fac.toDouble());
    majorEnvironmentalCases.value = _aggregateData(
        data, (report) => report.majorEnvironmentalCases.toDouble());
    animalAndInsectBiteCases.value = _aggregateData(
        data, (report) => report.animalAndInsectBiteCases.toDouble());
    dangerousOccurrences.value = _aggregateData(
        data, (report) => report.dangerousOccurrences.toDouble());
    nearMissIncidents.value =
        _aggregateData(data, (report) => report.nearMissIncidents.toDouble());
    fireCases.value =
        _aggregateData(data, (report) => report.fireCases.toDouble());
    manDaysLost.value =
        _aggregateData(data, (report) => report.manDaysLost.toDouble());
    fr.value = _aggregateData(data, (report) => report.fr.toDouble());
    sr.value = _aggregateData(data, (report) => report.sr.toDouble());
    safeLtiFreeDays.value =
        _aggregateData(data, (report) => report.safeLtiFreeDays.toDouble());
    safeLtiFreeManHours.value =
        _aggregateData(data, (report) => report.safeLtiFreeManHours.toDouble());
    ncrPenaltyWarnings.value =
        _aggregateData(data, (report) => report.ncrPenaltyWarnings.toDouble());
    suggestionsReceived.value =
        _aggregateData(data, (report) => report.suggestionsReceived.toDouble());
    safetyItemsInspections.value = _aggregateData(
        data, (report) => report.safetyItemsInspections.toDouble());
    safetyCommitteeMeetings.value = _aggregateData(
        data, (report) => report.safetyCommitteeMeetings.toDouble());
    internalAudits.value =
        _aggregateData(data, (report) => report.internalAudits.toDouble());
    externalAudits.value =
        _aggregateData(data, (report) => report.externalAudits.toDouble());
    awardsAndAppreciations.value = _aggregateData(
        data, (report) => report.awardsAndAppreciations.toDouble());
    safetyAwardRatingHighest.value = _aggregateData(
        data, (report) => report.safetyAwardRatingHighest.toDouble());
    safetyAwardRatingLowest.value = _aggregateData(
        data, (report) => report.safetyAwardRatingLowest.toDouble());

    safetyTraining.value = computeDerivedChart(
        inputs: {
          'inductions': safetyInduction,
          'tbt': tbtMeetingHours,
          'specific': specificSafetyTrainingHours,
          'totalhrs': totalManHoursWorked
        },
        formula: (values) {
          final inductions = values['inductions'] ?? 0;
          final tbt = values['tbt'] ?? 0;
          final specific = values['specific'] ?? 0;
          final totalhrs = values['totalhrs'] ?? 0;

          return ((inductions + tbt + specific) / totalhrs) * 100;
        });

    fr.value = computeDerivedChart(
        inputs: {'lti': ltiCases, 'totalhrs': totalManHoursWorked},
        formula: (values) {
          final lti = values['lti'] ?? 0;
          final totalhrs = values['totalhrs'] ?? 0;
          return (lti * 1000000) / totalhrs;
        });
    sr.value = computeDerivedChart(
        inputs: {'mdl': manDaysLost, 'totalhrs': totalManHoursWorked},
        formula: (values) {
          final mdl = values['mdl'] ?? 0;
          final totalhrs = values['totalhrs'] ?? 0;
          return (mdl * 1000000) / totalhrs;
        });
    totalManHoursWorkedinM.value = computeDerivedChart(
        inputs: {"totalManHoursWorked": totalManHoursWorked},
        formula: (values) {
          final totalManHoursWorked = values["totalManHoursWorked"] ?? 0;

          return totalManHoursWorked / 1000;
        });
  }

  void updateDataForCustomDateRange(DateTime startDate, DateTime endDate) {
    final filteredData = Strings.safetyreport
        .map((e) => SafetyReportModel.fromJson(e))
        .where((report) =>
            report.createdAt.isAfter(startDate.subtract(Duration(days: 1))) &&
            report.createdAt.isBefore(endDate.add(Duration(days: 1))))
        .toList();

    _updateChartData(filteredData);
  }

  void filterSafetyReportsByProject(String? projectId) {
    if (projectId == "All") {
      // Show all reports if no project is selected
      safetyReportData.value = Strings.safetyreport
          .map((e) => SafetyReportModel.fromJson(e))
          .toList();
      _populateChartData();
    } else {
      // Filter reports by projectId
      safetyReportData.value = Strings.safetyreport
          .map((e) => SafetyReportModel.fromJson(e))
          .where((report) => report.project.id == projectId)
          .toList();
    }

    // safetyReportData.value = filteredReports; // Update filtered data
    _populateChartData(); // Update charts with the filtered data
  }

  List<ChartData> computeDerivedChart({
    required Map<String, List<ChartData>> inputs,
    required double Function(Map<String, double> values) formula,
  }) {
    // Convert each ChartData list to a Map<category, value>
    final Map<String, Map<String, double>> categoryToValues = {};

    inputs.forEach((sourceKey, chartList) {
      for (var chart in chartList) {
        categoryToValues.putIfAbsent(chart.category, () => {});
        categoryToValues[chart.category]![sourceKey] = chart.value;
      }
    });

    final List<ChartData> result = [];

    categoryToValues.forEach((category, values) {
      try {
        double computed = double.parse(formula(values).toStringAsFixed(2));
        result.add(ChartData(category, computed));
      } catch (e) {
        result.add(ChartData(category, 0)); // fallback on error
      }
    });

    return result;
  }

  /// Aggregates data by summing values for a specific period
  List<ChartData> _aggregateData(
    List<SafetyReportModel> data,
    double Function(SafetyReportModel) valueSelector,
  ) {
    final Map<String, double> aggregatedData = {};

    for (var report in data) {
      String? periodKey = _getPeriodKey(report.createdAt);
      if (periodKey == null) continue; // Skip if periodKey is null

      aggregatedData[periodKey] =
          (aggregatedData[periodKey] ?? 0) + valueSelector(report);
    }

    return aggregatedData.entries
        .map((entry) =>
            ChartData(entry.key, double.parse(entry.value.toStringAsFixed(2))))
        .toList();
  }

  /// Returns the period key (e.g., "2023-01 (Monthly)" or "2023-Q1 (Quarterly)")
  String? _getPeriodKey(DateTime date) {
    switch (_selectedFilter) {
      case "Weekly":
        if (selectedWeek != null &&
            selectedWeek!.containsKey('start') &&
            selectedWeek!.containsKey('end')) {
          final start = selectedWeek!['start'] as DateTime;
          final end = selectedWeek!['end'] as DateTime;

          if (date.isAfter(start.subtract(Duration(days: 1))) &&
              date.isBefore(end.add(Duration(days: 1)))) {
            return "${date.day}-${date.month}-${date.year}";
          }
        }
        return null;

      case "Monthly":
        if (date.year.toString() == selectedYear.value &&
            selectedMonth.value == date.month) {
          return "${date.day}-${date.month}";
        }
        return null;

      case "Quarterly":
        final quarter = ((date.month - 1) ~/ 3) + 1;
        final startMonth = (quarter - 1) * 3 + 1;
        final startOfQuarter = DateTime(date.year, startMonth, 1);
        final weekNumber = ((date.difference(startOfQuarter).inDays) ~/ 7) + 1;
        if (date.year.toString() == selectedYear.value &&
            selectedQuarter.value == "Quarter $quarter") {
          return "Q$quarter - Week $weekNumber";
        }
        return null;

      case "Yearly":
        if (date.year.toString() == selectedYear.value) {
          return "${getMonthName(date.month)} $selectedYear";
        }
        return null;

      case "Recent":
        return _formatDate(date);

      default:
        final monthName = getMonthName(date.month);
        return "$monthName, ${date.year}";
    }
  }

  String getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  /// Formats date as 'YYYY-MM-DD'
  String _formatDate(DateTime date) {
    return IndianDateFormatters.formatDate1(date);
  }

  /// Updates chart data based on the selected filter
  void updateDataForFilter(String filter) {
    _selectedFilter = filter;
    List<SafetyReportModel> filteredData;

    if (filter == "Recent") {
      filteredData = filterLatestEntries(7);
    } else {
      filteredData =
          safetyReportData.toList(); // No additional filtering for now.
    }

    _updateChartData(filteredData);
  }

  String _selectedFilter = "Recent";

  /// Fetches the latest N entries for daily display
  List<SafetyReportModel> filterLatestEntries(int count) {
    // Reverse the list to get the most recent entries first, then take the desired count
    return safetyReportData
        .toList()
        .reversed
        .take(count)
        .toList()
        .reversed
        .toList();
  }
}
