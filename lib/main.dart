import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/colors.dart';
import 'package:sure_safe/routes/routes.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/connection_service.dart';
import 'package:sure_safe/services/firebase_service.dart';
import 'package:sure_safe/services/jwt_service.dart';
import 'package:sure_safe/services/load_dropdown_data.dart';
import 'package:sure_safe/services/notification_service/notification_handler.dart';
import 'package:sure_safe/services/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Widgets binding initialized');
  Get.put(NotificationHandler());
  // Setup environment
  try {
    // AppEnvironment.setupEnv(Environment.dev);
    // print('Environment setup done');
    await loadDropdownData();
    // Initialize Firebase
    await Firebase.initializeApp();
    print('Firebase initialized');

    // Initialize Firebase notifications
    await FirebaseApi().initNotifications();
    print('Notifications initialized');

    // Background handler for FCM
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print('Background message handler set');

    // Check if the user is logged in
    bool isLoggedIn = await isTokenValid();
    print('Token valid: $isLoggedIn');

    // Run the app
    runApp(MyApp(isLoggedIn: isLoggedIn));
  } catch (e) {
    print('Error initializing Firebase: $e');

    // Handle Firebase initialization error
    try {
      print(
          "000000000000000000000 -- Operating from Main failed Block---0000000000000");
      await requestEssentialPermissions();
// await loadDropdownData();
      bool isLoggedIn = await isTokenValid();
      runApp(MyApp(isLoggedIn: isLoggedIn));
    } catch (innerError) {
      print('Error in fallback logic: $innerError');
      runApp(const MyApp(isLoggedIn: false));
    }
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized before handling the background message
  await Firebase.initializeApp();
  try {
    // Access the NotificationController
    NotificationHandler notificationController =
        Get.find<NotificationHandler>();
    notificationController.getNotifications(); // Call the method
    print('getNotifications called successfully');
  } catch (e) {
    print('Error calling getNotifications: $e');
  }
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(ConnectivityService());
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: AppColors.appMainDark,
            foregroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appMainDark),
        useMaterial3: false,
      ),
      initialRoute: isLoggedIn ? Routes.homePage : Routes.loginPage,
      getPages: AppRoutes.routes,
    );
  }
}
