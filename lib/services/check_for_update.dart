import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/api_services.dart';
import 'package:sure_safe/widgets/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckForUpdate {
  var isUpdateAvailable = false.obs;
  var latestVersion = ''.obs;
  var updateLink = ''.obs;
  Future<void> checkForUpdate() async {
    final currentVersion = await getCleanVersion();
    print('Current version: $currentVersion');

    final response = await ApiService().getRequest("apk/latest");

    if (response != null) {
      final data = response;

      if (data['success'] == true) {
        latestVersion.value = data['version'];
        updateLink.value = data['link'];

        if (_isNewerVersion(latestVersion.value, currentVersion)) {
          isUpdateAvailable.value = true;
          showUpdateDialog(updateLink.value);
        }
      }
    }
  }

  Future<String> getCleanVersion() async {
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

  void showUpdateDialog(String updateUrl) {
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
            onTap: () => launchUpdateLink(updateUrl),
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
                'lib/assets/animations_josn/warning.json',
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
          TextButton(
              onPressed: () {
                Get.offAllNamed(Routes.loginPage);
              },
              child: Text("Still Skip")),
          TextButton(
            onPressed: () {
              Get.back(); // Close warning dialog
              showUpdateDialog(updateLink.value);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void launchUpdateLink(String url) async {
    await clearAppCache();
    final uri = Uri.parse(url);
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
