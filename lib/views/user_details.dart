import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/colors.dart';
import 'package:sure_safe/controllers/user_details_controller.dart';
import 'package:sure_safe/helpers/sixed_boxes.dart';
import 'package:sure_safe/routes/routes_string.dart';

class USerDetailsData extends StatelessWidget {
  USerDetailsData({super.key});
  final controller = Get.put(UserDetailsDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160, // enough to show highlights
            backgroundColor: AppColors.appMainDark,
            foregroundColor: Colors.white,
            //toolbarHeight: 70,

            // Top bar: Title or SearchField
            title: Obx(() {
              return controller.isSearching.value
                  ? TextField(
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Search by name...",
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) =>
                          controller.searchQuery.value = value,
                    )
                  : Text("Project Stats",
                      style: TextStyle(color: Colors.white));
            }),

            // Right-side icons
            actions: [
              Obx(() {
                return controller.isSearching.value
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          controller.isSearching.value = false;
                          controller.searchQuery.value = '';
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          controller.isSearching.value = true;
                        },
                      );
              }),
              IconButton(
                icon: Icon(Icons.refresh_rounded),
                onPressed: () {
                  controller.groupDataByUser();
                },
              ),
              IconButton(
                icon: const Icon(Icons.home_rounded),
                onPressed: () {
                  Get.offAllNamed(Routes.homePage);
                },
              ),
            ],

            // Bottom part of AppBar
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                  padding: const EdgeInsets.only(
                      top: 100.0, left: 12, right: 12, bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    // margin:
                    //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                            "Unresolved\nUAUC",
                            controller.totalUnresolved.toString(),
                            Colors.teal.shade900),
                        sb1,
                        _divider(),
                        _buildStatCard(
                            "Work\nPermits",
                            controller.totalWorkPermits.toString(),
                            Colors.blue.shade900),
                        _divider(),
                        _buildStatCard(
                            "UAUC\nReported",
                            controller.totalUAUCs.toString(),
                            Colors.orange.shade900),
                        _divider(),
                        _buildStatCard(
                            "TBT\nMeetings",
                            controller.totalTBTs.toString(),
                            Colors.green.shade900),
                        _divider(),
                        _buildStatCard(
                            "\nInductions",
                            controller.totalInductions.toString(),
                            Colors.deepPurple.shade900),
                        _divider(),
                        _buildStatCard(
                            "Specific\nTraining",
                            controller.totalSpecificTrainings.toString(),
                            Colors.teal.shade900),
                      ],
                    ),
                  )),
            ),
          ),

          // Body content here
          Obx(() {
            final data = controller.filteredUserData;
            print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
            print('filteredUserData: ${controller.filteredUserData}'); // debug
            print('length: ${controller.filteredUserData.length}');
            return SliverPadding(
              padding: const EdgeInsets.all(0.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = data[index];
                    final user = entry['user'];
                    final wp = entry['workPermits'];
                    final tbt = entry['tbts'];
                    final uauc = entry['uaucs'];
                    final specific = entry['specific'];
                    final induction = entry['inductions'];
                    final unresolved = entry['unresolvedUaucs'];

                    return StatsCard(
                      name: user["name"],
                      role: user["role"]["roleName"],
                      contactNumber: user["phone"],
                      workpermits: wp,
                      meetings: tbt,
                      uaucs: uauc,
                      specific: specific,
                      inductions: induction,
                      unresolved: unresolved,
                    );
                  },
                  childCount: data.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String? name;
  final String? contactNumber;
  final String? role;
  final String? timeRange;
  final String? examinerName;
  final String? examinerRole;
  final String? examType;
  final String? profileImageUrl;
  final List<dynamic>? workpermits;
  final List<dynamic>? uaucs;
  final List<dynamic>? meetings;
  final List<dynamic>? specific;
  final List<dynamic>? inductions;
  final List<dynamic>? unresolved;

  const StatsCard(
      {super.key,
      this.name,
      this.contactNumber,
      this.role,
      this.timeRange,
      this.examinerName,
      this.examinerRole,
      this.examType,
      this.profileImageUrl,
      this.workpermits,
      this.uaucs,
      this.meetings,
      this.inductions,
      this.specific,
      this.unresolved});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  child: profileImageUrl == null
                      ? Icon(Icons.person, size: 28)
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name != null
                            ? capitalizeEachWord(name!)
                            : 'Unknown User',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        contactNumber ?? 'No contact info',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                if (role != null)
                  Container(
                    height: 30,
                    width: 100, // fixed width for all role tags
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      capitalizeEachWord(role!), // "admin" ➜ "Admin"
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: getRoleColor(role!),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 12),
            Divider(thickness: 1, color: Colors.grey),

            /// Stats
            /// Stats
            SizedBox(
              height: 60, // fixed height to make VerticalDivider visible
              child: Row(
                children: [
                  Expanded(
                    child: StatItem(
                      title: "Work\nPermits",
                      value: role == "Execution"
                          ? "${workpermits?.length ?? 0}"
                          : "N/A",
                      onTap: () async {
                        await Get.toNamed(Routes.userDetailsListView,
                            arguments: [name, "Work Permits", workpermits]);
                      },
                    ),
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey),
                  Expanded(
                    child: StatItem(
                      title: "UAUC\nReported",
                      value: role == "Safety" ? "${uaucs?.length ?? 0}" : "N/A",
                      onTap: () async {
                        await Get.toNamed(Routes.userDetailsListView,
                            arguments: [name, "UaUc's", uaucs]);
                      },
                    ),
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey),
                  Expanded(
                    child: StatItem(
                      title: "Unresolved\nUAUC",
                      value: role == "Execution"
                          ? "${unresolved?.length ?? 0}"
                          : "N/A",
                      onTap: () async {
                        await Get.toNamed(Routes.userDetailsListView,
                            arguments: [name, "Unresolved UaUc's", unresolved]);
                      },
                    ),
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey),
                  Expanded(
                    child: StatItem(
                      title: "TBT\nMeetings",
                      value:
                          role == "Safety" ? "${meetings?.length ?? 0}" : "N/A",
                      onTap: () async {
                        await Get.toNamed(Routes.userDetailsListView,
                            arguments: [name, "TBT Meetings", meetings]);
                      },
                    ),
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey),
                  Expanded(
                    child: StatItem(
                      title: "Safety\nInductions",
                      value: role == "Safety"
                          ? "${inductions?.length ?? 0}"
                          : "N/A",
                      onTap: () async {
                        await Get.toNamed(Routes.userDetailsListView,
                            arguments: [name, "Safety Inductions", inductions]);
                      },
                    ),
                  ),
                  VerticalDivider(thickness: 1, color: Colors.grey),
                  Expanded(
                    child: StatItem(
                      title: "Specific\nTraining",
                      value:
                          role == "Safety" ? "${specific?.length ?? 0}" : "N/A",
                      onTap: () async {
                        await Get.toNamed(Routes.userDetailsListView,
                            arguments: [name, "Specific Training", specific]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;
  final void Function()? onTap;

  const StatItem({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 70, // Slightly taller to support multi-line titles
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: value == "N/A" ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String capitalizeEachWord(String input) {
  return input
      .split(' ')
      .map((word) =>
          word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
      .join(' ');
}

Color getRoleColor(String role) {
  switch (role.toLowerCase()) {
    case 'admin':
      return Colors.blue;
    case 'execution':
      return Colors.green.shade900;
    case 'safety':
      return Colors.purple.shade900;
    default:
      return Colors.grey;
  }
}

Widget _divider() {
  return Container(
    height: 60,
    width: 1.5,
    color: Colors.black,
  );
}

Widget _buildStatCard(String title, String value, Color color) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              height: 1.2,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}



//////////////backup code
///  // appBar: AppBar(
      //   toolbarHeight: 100,
      //   foregroundColor: Colors.white,
      //   backgroundColor: AppColors.appMainDark,
      //   title: Column(
      //     children: [
      //       Obx(() {
      //         return controller.isSearching.value
      //             ? TextField(
      //                 autofocus: true,
      //                 style: TextStyle(color: Colors.white),
      //                 cursorColor: Colors.white,
      //                 decoration: InputDecoration(
      //                   hintText: "Search by name...",
      //                   hintStyle: TextStyle(color: Colors.white70),
      //                   border: InputBorder.none,
      //                 ),
      //                 onChanged: (value) =>
      //                     controller.searchQuery.value = value,
      //               )
      //             : Text("Project Stats",
      //                 style: TextStyle(color: Colors.white));
      //       }),
      //       //Highlights Row
      //       SizedBox(
      //         height: 60, // fixed height to make VerticalDivider visible
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: StatItem(
      //                   title: "Work\nPermits",
      //                   value: controller.totalWorkPermits.toString()),
      //             ),
      //             VerticalDivider(thickness: 1, color: Colors.grey),
      //             Expanded(
      //               child: StatItem(
      //                   title: "UAUC\n",
      //                   value: controller.totalUAUCs.toString()),
      //             ),
      //             VerticalDivider(thickness: 1, color: Colors.grey),
      //             Expanded(
      //               child: StatItem(
      //                   title: "TBT\nMeetings",
      //                   value: controller.totalTBTs.toString()),
      //             ),
      //             VerticalDivider(thickness: 1, color: Colors.grey),
      //             Expanded(
      //               child: StatItem(
      //                   title: "Inductions\n",
      //                   value: controller.totalInductions.toString()),
      //             ),
      //             VerticalDivider(thickness: 1, color: Colors.grey),
      //             Expanded(
      //               child: StatItem(
      //                 title: "Specific\nTraining",
      //                 value: controller.totalSpecificTrainings.toString(),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     Obx(() {
      //       return controller.isSearching.value
      //           ? IconButton(
      //               icon: Icon(Icons.close),
      //               onPressed: () {
      //                 controller.isSearching.value = false;
      //                 controller.searchQuery.value = '';
      //               },
      //             )
      //           : IconButton(
      //               icon: Icon(Icons.search),
      //               onPressed: () {
      //                 controller.isSearching.value = true;
      //               },
      //             );
      //     }),
      //     IconButton(
      //       icon: Text(controller.uaucs.length.toString()),
      //       onPressed: () {
      //         controller.groupDataByUser();
      //       },
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.home_filled),
      //       onPressed: () {
      //         Get.offAllNamed(Routes.homePage);
      //       },
      //     ),
      //   ],
      //   elevation: 2,
      // ),
      // body: Scaffold(

      // Obx(() {
//   final data = controller.filteredUserData;

//   return ListView.builder(
//     itemCount: data.length,
//     itemBuilder: (context, index) {
//       final entry = data[index];
//       final user = entry['user'];
//       final wp = entry['workPermits'];
//       final tbt = entry['tbts'];
//       final uauc = entry['uaucs'];
//       final specifc = entry['specific'];
//       final induction = entry['inductions'];

//       return StatsCard(
//         name: user["name"],
//         role: user["role"]["roleName"],
//         contactNumber: user["phone"],
//         workpermits: wp,
//         meetings: tbt,
//         uaucs: uauc,
//         specific: specifc,
//         inductions: induction,
//       );
//     },
//   );
// }),