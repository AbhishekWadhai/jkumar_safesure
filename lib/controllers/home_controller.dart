import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/api_services.dart';
import 'package:sure_safe/services/load_dropdown_data.dart';
import 'package:sure_safe/widgets/gradient_button.dart';
import 'package:sure_safe/widgets/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  // RxList<UaUc> uaucList = <UaUc>[].obs;
  // RxList<WorkPermit> permitList = <WorkPermit>[].obs;
  RxInt permitCount = 0.obs;
  RxInt uaucCount = 0.obs;
  String? payLoad;
  var hasPendingActions = false.obs;
  var currentIndex = 1.obs;
  var isUpdateAvailable = false.obs;
  var latestVersion = ''.obs;
  var updateLink = ''.obs;
  Rx<DateTimeRange> selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  ).obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    checkForUpdate();
    getFormField();
    // ConnectivityService.checkAndShowOfflineSnackbar();
    // await loadDropdownData();
    await getPermitData("uauc");
    await getPermitData("workpermit");

    //checkPendingActions();
  }

  @override
  void onReady() {
    super.onReady();
    // This will be called when the HomeController is ready
    // Use this to check pending actions when the view is displayed
    // ever(uaucList, (_) => checkPendingActions());
  }

  changeProject(dynamic project) async {
    // Set project in your list
    Strings.endpointToList["project"] = project;

    // Show loading dialog
    Get.dialog(
      Center(child: CustomProgressIndicator()),
      barrierDismissible: false,
    );

    // Load dropdown data
    await loadDropdownData();

    // Close loader
    Get.back();

    // Navigate to homepage
    Get.offAllNamed(Routes.homePage);

    print(Strings.endpointToList["project"]);
  }

  getFormField() async {
    try {
      List<dynamic> fieldData = await ApiService().getRequest("fields");
      var project = fieldData.firstWhere(
        (item) =>
            item["project"]["_id"] == Strings.endpointToList['project']['_id'],
        orElse: () => null, // Return null if no match is found
      );
      Strings.workpermitPageFild = project["fields"];
    } catch (e) {
      print(e);
    }
  }

  getPermitData(String endpoint) async {
    try {
      final apiData = await ApiService().getRequest(endpoint);

      if (apiData == null) {
        throw Exception("Received null data from API");
      }

      // Ensure that the API response is a List of Map<String, dynamic>
      // if (apiData is List) {
      //   // Check for any null elements in the list
      //   if (endpoint == "uauc") {
      //     uaucList.value = apiData
      //         .where((e) => e != null)
      //         .map((e) => UaUc.fromJson(e as Map<String, dynamic>))
      //         .toList();
      //     uaucCount.value = uaucList.length;
      //   } else {
      //     permitList.value = apiData
      //         .where((e) => e != null)
      //         .map((e) => WorkPermit.fromJson(e as Map<String, dynamic>))
      //         .toList();

      //     permitCount.value = permitList.length;
      //   }
      // } else {
      //   throw Exception("Unexpected data format");
      // }
    } catch (e) {
      print("Error fetching permit data: $e");
      // Handle the error accordingly, e.g., show a dialog or retry
    }
  }

  void checkPendingActions() {
    // hasPendingActions.value = uaucList.any((uauc) =>
    //     uauc.assignedTo?.id == Strings.userId && uauc.status == "Open");
  }

  Future<void> checkForUpdate() async {
    final currentVersion = await _getCleanVersion();
    print('Current version: $currentVersion');

    final response = await ApiService().getRequest("apk");

    if (response != null) {
      final data = response;

      if (data['success'] == true) {
        latestVersion.value = data['version'];
        updateLink.value = data['link'];

        if (_isNewerVersion(latestVersion.value, currentVersion)) {
          isUpdateAvailable.value = true;
          _showUpdateDialog();
        }
      }
    }
  }

  Future<String> _getCleanVersion() async {
    final info = await PackageInfo.fromPlatform();
    final raw = "${info.version}+${info.buildNumber}";

    // Clean the version by removing the build number and any '-dev' suffix
    return raw
        .split('+')
        .first // Get the version part (e.g., 1.0.3)
        .split('-')
        .first; // Remove any '-dev' or similar suffix
  }

  bool _isNewerVersion(String latest, String current) {
    List<int> parseVersion(String version) {
      return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    }

    final latestParts = parseVersion(latest);
    final currentParts = parseVersion(current);

    for (int i = 0; i < 3; i++) {
      if (latestParts.length <= i) break;
      if (latestParts[i] > (currentParts.length > i ? currentParts[i] : 0)) {
        return true;
      } else if (latestParts[i] <
          (currentParts.length > i ? currentParts[i] : 0)) {
        return false;
      }
    }
    return false;
  }

  void _showUpdateDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Update Available"),
        content: Text(
            "Please Update to latest version $latestVersion for seamless experience"),
        actions: [
          TextButton(
            onPressed: () {
              // Show a warning dialog when "Later" is pressed
              Get.back(); // Close the first dialog
              _showLaterWarningDialog();
            },
            child: Text("Later"),
          ),
          Container(
              child: GradientButton(
            height: 30,
            width: 90,
            onTap: launchUpdateLink,
            text: "Update",
            shadowColor: Colors.transparent,
          )),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showLaterWarningDialog() {
    Get.dialog(
      AlertDialog(
        title: Center(
            child: Text(
          "WARNING",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min, // 👈 keeps dialog compact
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center, // 👈 center Lottie without expanding
              child: Lottie.asset(
                'assets/animations_josn/warning.json',
                height: 100,
                width: 100,
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Skipping the update might cause issues. Are you sure?",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Still Skip")),
          TextButton(
            onPressed: () {
              Get.back(); // Close warning dialog
              _showUpdateDialog();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void launchUpdateLink() async {
    await clearAppCache();
    final uri = Uri.parse(updateLink.value);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> clearAppCache() async {
    try {
      // Clear temporary/cache directory
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      // Clear SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.clear();

      // Clear GetX memory/controllers
      Get.reset();
      await Get.deleteAll(force: true);

      // Optional: Clear GetStorage or Hive if you're using them
      // await GetStorage().erase();
      // await Hive.box('yourBoxName').clear();

      print("App cache and SharedPreferences cleared.");
    } catch (e) {
      print("Error clearing cache or preferences: $e");
    }
  }
}
