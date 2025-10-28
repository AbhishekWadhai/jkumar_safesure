import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sure_safe/controllers/notification_controller.dart';
import 'package:sure_safe/helpers/sixed_boxes.dart';
import 'package:sure_safe/model/notification_model.dart' as custom;
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/widgets/notificatio_tile.dart';

class NotificationPage extends StatelessWidget {
  // Instantiate the NotificationController
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.notifications_sharp),
              sb10,
              const Text("Notifications"),
            ],
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () {
                  notificationController.refreshNotifications();
                }),
          ],
        ),
        body: Container(
          child: Obx(() {
            // Using Obx to reactively update the UI when the notifications list changes
            return notificationController.notifications.isEmpty
                ? const Center(child: Text("No notifications"))
                : Column(
                    children: [
                      sb4,
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              notificationController.notifications.length,
                          itemBuilder: (context, index) {
                            return ModernNotificationTile(
                              notification:
                                  notificationController.notifications[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
          }),
        ));
  }
}

class NotificationTile extends StatelessWidget {
  final custom.Notification notification;

  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Tile background color
          borderRadius:
              BorderRadius.circular(8), // Optional: to round the corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              blurRadius: 5, // Blur radius
              spreadRadius: 2, // Spread radius
              offset: const Offset(0, 2), // Shadow direction (vertical shift)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            style: ListTileStyle.drawer,
            leading: CircleAvatar(
              backgroundColor: notification.isRead ? Colors.grey : Colors.blue,
              child: Icon(
                notification.isRead
                    ? Icons.notifications
                    : Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            title: Text(
              notification.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the content vertically
              children: [
                Text(
                  notification.createdAt != null
                      ? _formatDate(notification.createdAt)
                      : 'Unknown Date',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  notification.createdAt != null
                      ? _formatTime(notification.createdAt)
                      : '',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            onTap: () {
              // Handle tile tap here
              switch (notification.source) {
                case 'workpermit':
                  // Navigate to a specific page for source1
                  Get.toNamed(Routes.workPermitPage);
                  break;
                case 'uauc':
                  // Navigate to a specific page for source2
                  Get.toNamed(Routes.soraPage);
                  break;
                case 'meeting':
                  // Navigate to a specific page for source3
                  Get.toNamed(Routes.tbtMeetingPage);
                  break;
                case 'specific':
                  // Navigate to a specific page for source4
                  Get.toNamed(Routes.speceficTrainingPage);
                  break;
                case 'induction':
                  // Navigate to a specific page for source5
                  Get.toNamed(Routes.safetyInductionPage);

                  break;
                default:
                  // Default navigation if none of the cases match
                  Get.toNamed(Routes.workPermitPage);
              }
            },
          ),
        ),
      ),
    );
  }
}

String _formatDate(String dateTime) {
  final date = DateTime.parse(dateTime).toLocal();
  return DateFormat('d MMM').format(date); // e.g., "27 Dec"
}

// Method to format the time
String _formatTime(String dateTime) {
  final time = DateTime.parse(dateTime).toLocal();
  return DateFormat('h:mm a').format(time); // e.g., "6:00 PM"
}
