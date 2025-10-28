import 'package:get/get.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/model/notification_model.dart';
import 'package:sure_safe/services/notification_service/notification_handler.dart';

class NotificationController extends GetxController {
  // Sample list of notifications
  RxList<Notification> notifications = <Notification>[].obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await NotificationHandler().getNotifications();
    getNotifications();
  }

  refreshNotifications() async {
    Strings.notifications["notifications"] =
        await NotificationHandler().getNotifications();
    getNotifications();
  }

  getNotifications() {
    // Ensure `Strings.notifications["notifications"]` is a List
    if (Strings.notifications["notifications"] is List) {
      notifications.value = (Strings.notifications["notifications"] as List)
          .map((item) => Notification.fromJson(
              item)) // Convert each item to Notification model
          .toList(); // Convert the iterable back to a list
    } else {
      // Handle cases where notifications data is not a list
      notifications.value = [];
      print("No valid notifications found in Strings.notifications.");
    }
  }
}
