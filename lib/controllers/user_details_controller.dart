import 'package:get/get.dart';
import 'package:sure_safe/app_constants/app_strings.dart';

class UserDetailsDataController extends GetxController {
  List<dynamic> users = List<dynamic>.from(Strings.endpointToList["user"]);
  List<dynamic> workPermits = Strings.workpermit;
  List<dynamic> tbtMeetings = Strings.meetings;
  List<dynamic> uaucs = Strings.uauc;
  List<dynamic> specificTrainings = Strings.specific;
  List<dynamic> inductions = Strings.induction;
  List<dynamic> unresolvedUauc = [];

  final RxBool isSearching = false.obs;
  final groupedUserData = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    groupDataByUser();
  }

  void groupDataByUser() {
    final grouped = users.where((user) {
      final roleName = user['role']?['roleName'];
      final userProjects = user['project'] as List<dynamic>?;
      print(
          "Working here -------------------------${workPermits.length}--${tbtMeetings.length}");
      return (roleName == 'Safety' || roleName == 'Execution') &&
          (userProjects?.any((proj) =>
                  proj['_id'] == Strings.endpointToList['project']?['_id']) ??
              false);
    }).map((user) {
      final userId = user['_id'];

      return {
        "user": user,
        "workPermits": workPermits
            .where((wp) => wp['createdby']?['_id'] == userId)
            .toList(),
        "tbts": tbtMeetings
            .where((tbt) => tbt['createdby']?['_id'] == userId)
            .toList(),
        "uaucs":
            uaucs.where((uauc) => uauc['createdby']?['_id'] == userId).toList(),
        "specific": specificTrainings
            .where((spec) => spec['createdby']?['_id'] == userId)
            .toList(),
        "inductions": inductions
            .where((induction) => induction['createdby']?['_id'] == userId)
            .toList(),
        "unresolvedUaucs": uaucs
            .where((unresolved) =>
                unresolved['assignedTo'] != null &&
                (unresolved['assignedTo'] as List)
                    .any((a) => a['_id'] == userId) &&
                unresolved['status'] == "Open")
            .toList(),
      };
    }).toList();

    groupedUserData.assignAll(grouped);
  }

  /// Filtered data based on search
  List<Map<String, dynamic>> get filteredUserData {
    if (searchQuery.value.trim().isEmpty) return groupedUserData;
    final query = searchQuery.value.toLowerCase();
    return groupedUserData.where((entry) {
      final name = entry['user']?['name']?.toString().toLowerCase() ?? '';
      return name.contains(query);
    }).toList();
  }

  /// Totals (based on all data, not filtered)
  int get totalWorkPermits {
    return groupedUserData.fold(
        0, (sum, entry) => sum + (entry['workPermits'] as List).length);
  }

  int get totalTBTs {
    return groupedUserData.fold(
        0, (sum, entry) => sum + (entry['tbts'] as List).length);
  }

  int get totalUAUCs {
    return groupedUserData.fold(
        0, (sum, entry) => sum + (entry['uaucs'] as List).length);
  }

  int get totalSpecificTrainings {
    return groupedUserData.fold(
        0, (sum, entry) => sum + (entry['specific'] as List).length);
  }

  int get totalInductions {
    return groupedUserData.fold(
        0, (sum, entry) => sum + (entry['inductions'] as List).length);
  }

  int get totalUnresolved {
    return groupedUserData.fold(
        0, (sum, entry) => sum + (entry['unresolvedUaucs'] as List).length);
  }

  int get totalAllItems {
    return totalWorkPermits +
        totalTBTs +
        totalUAUCs +
        totalSpecificTrainings +
        totalInductions;
  }
}
