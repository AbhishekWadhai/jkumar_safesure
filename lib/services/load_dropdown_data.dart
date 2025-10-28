import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/services/api_services.dart';
import 'package:sure_safe/services/shared_preferences.dart';

Future<void> loadDropdownData() async {
  print("----------------${Strings.endpointToList["project"]}------------------");
  List<String> endpoints = [
    "projects",
    "permitstype",
    "user",
    "topic",
    "riskRating",
    "tools",
    "equipments",
    "machinetools",
    "hazards",
    "ppe",
    "trade",
    "workpermit",
    "meeting",
    "specific",
    "uauc",
    "induction",
    "safetyreport"
  ];

  // Optional: Define parsers in case you need custom transformations later
  final Map<String, Function> endpointToModelParser = {
    for (var endpoint in endpoints) endpoint: (List data) => data,
  };

  // Check internet status once
  final connectivityResultList = await Connectivity().checkConnectivity();
  final bool isOnline =
      connectivityResultList.any((result) => result != ConnectivityResult.none);

  // Iterate each endpoint
  List<Future<void>> requests = endpoints.map((endpoint) async {
    List<dynamic> parsedData = [];

    try {
      if (isOnline) {

        print("🟢 [$endpoint] Fetched ${parsedData.length} items from API");

        final List<dynamic> response = await ApiService().getRequest(endpoint);
        final parser = endpointToModelParser[endpoint];
        parsedData = parser != null ? parser(response) : response;

        await SharedPrefService().saveDropdownListToPrefs(endpoint, parsedData);

        print("💾 [$endpoint] Saved to SharedPreferences");
      } else {
        // 🔹 Offline: load cached data
        print("''''''$endpoint---------------------------------");
        parsedData =
            await SharedPrefService().getDropdownListFromPrefs(endpoint) ?? [];
        print(
            "📦 [$endpoint] Loaded from SharedPreferences: ${parsedData.length} items");
      }

      // 🔹 Assign data to app memory (Constants)
      switch (endpoint) {
        case "projects":
          Strings.endpointToList["projects"] = parsedData;
          break;

        case "permitstype":
          Strings.endpointToList["permitstype"] = parsedData;
          break;

        case "user":
          if (Strings.roleName == "Admin") {
            Strings.endpointToList["user"] = parsedData;
          } else {
            Strings.endpointToList["user"] = parsedData.where((user) {
              return (user['project'] as List).any((proj) =>
                  proj['_id'] == Strings.endpointToList['project']['_id']);
            }).toList();
          }

          // Additional role-based filtering
          Strings.endpointToList['safetyuser'] = parsedData
              .where((user) => user['role']['roleName'] == "Safety")
              .toList();

          Strings.endpointToList['managementuser'] = parsedData
              .where((user) => user['role']['roleName'] == "Management")
              .toList();

          Strings.endpointToList['exeuser'] = parsedData
              .where((user) =>
                  user['role']['roleName'] == "Execution" &&
                  (user['project'] as List).any((proj) =>
                      proj['_id'] == Strings.endpointToList['project']['_id']))
              .toList();
          break;

        case "topic":
        case "equipments":
        case "riskRating":
        case "tools":
        case "machinetools":
        case "hazards":
        case "ppe":
        case "trade":
          Strings.endpointToList[endpoint] = parsedData;
          break;

        case "workpermit":
          Strings.workpermit = parsedData
              .where((e) =>
                  e['project']['_id'] ==
                  Strings.endpointToList['project']['_id'])
              .toList();
          break;

        case "meeting":
          Strings.meetings = parsedData
              .where((e) =>
                  e['project']['_id'] ==
                  Strings.endpointToList['project']['_id'])
              .toList();
          break;

        case "specific":
          Strings.specific = parsedData
              .where((e) =>
                  e['project']['_id'] ==
                  Strings.endpointToList['project']['_id'])
              .toList();
          break;

        case "uauc":
          Strings.uauc = parsedData
              .where((e) =>
                  e['project']['_id'] ==
                  Strings.endpointToList['project']['_id'])
              .toList();
          break;

        case "induction":
          Strings.induction = parsedData
              .where((e) =>
                  e['project']['_id'] ==
                  Strings.endpointToList['project']['_id'])
              .toList();
          break;

        case "safetyreport":
          Strings.safetyreport = parsedData
              .where((e) =>
                  e['project']['_id'] ==
                  Strings.endpointToList['project']['_id'])
              .toList();

          break;
      }
    } catch (error) {
      print("⚠️ Error loading data for $endpoint: $error");

      // If offline and SharedPref fails too
      if (parsedData.isEmpty) {
        print("❌ No fallback data for $endpoint");
      }
    }
  }).toList();

  await Future.wait(requests);

  print("✅ Dropdown data loaded from ${isOnline ? 'API' : 'Cache'}.");
}
