import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/asset_path.dart';
import 'package:sure_safe/app_constants/colors.dart';
import 'package:sure_safe/widgets/my_drawer.dart';

import '../routes/routes_string.dart';

class SafetyTraining extends StatelessWidget {
  const SafetyTraining({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: AppColors.appMainDark,
          foregroundColor: Colors.white,
          title: const Text("Safety Training"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
            children: [
              TrainingCard(
                createAction: "Create TBT Meeting",
                moduleName: "TBT Meeting",
                imageAsset: Assets.tbtMeeting,
                action1: () {
                  Get.toNamed(Routes.modulePage, arguments: ["meeting"]);
                },
                action2: () {
                  Get.toNamed(
                    Routes.formPage,
                    arguments: ['meeting', <String, dynamic>{}, false],
                  );
                },
              ),
              TrainingCard(
                createAction: "Create Safety Induction",
                moduleName: "Safety Induction",
                imageAsset: Assets.safetyInduction,
                action1: () {
                  Get.toNamed(Routes.modulePage, arguments: ["induction"]);
                },
                action2: () {
                  Get.toNamed(
                    Routes.formPage,
                    arguments: ['induction', <String, dynamic>{}, false],
                  );
                },
              ),
              TrainingCard(
                createAction: "Create Job Specific Safety Training",
                moduleName: "Job Specific Safety Training",
                imageAsset: Assets.specificTraining,
                action1: () {
                  Get.toNamed(Routes.modulePage, arguments: ["specific"]);
                },
                action2: () {
                  Get.toNamed(
                    Routes.formPage,
                    arguments: ['specific', <String, dynamic>{}, false],
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class TrainingCard extends StatelessWidget {
  final String moduleName;
  final String imageAsset;
  final VoidCallback action1;
  final VoidCallback action2;
  final String createAction;

  const TrainingCard({
    super.key,
    this.moduleName = "",
    this.imageAsset = "assets/logo.png", // Default asset path
    required this.action1,
    required this.action2,
    this.createAction = "Create New",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [AppColors.appMainMid, AppColors.appMainDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // GestureDetector with expanded space
            Expanded(
              child: GestureDetector(
                onTap: action1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(12), // Optional: Rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(imageAsset),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        textAlign: TextAlign.center,

                        moduleName,
                        style: const TextStyle(
                            color: Colors.white), // Optional: For contrast
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            // Row for the second action
            GestureDetector(
              onTap: action2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      createAction,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(color: Colors.white), // Prevent overflow
                    ),
                  ),
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
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
