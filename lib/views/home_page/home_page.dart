import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/colors.dart';

import 'package:sure_safe/controllers/home_controller.dart';
import 'package:sure_safe/views/dashboard_view.dart';
import 'package:sure_safe/views/home_page/home_view.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> views = [
      DashboardView(),

      HomeView(controller: controller),
      //NotificationPage()
      Container()
    ];
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 1) {
          controller.changeTabIndex(1); // Go to Home tab
          return false; // Don't exit app
        }
        return true; // Exit app
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTabIndex,
              selectedItemColor: AppColors.appMainMid,
              unselectedItemColor: Colors.grey.shade600,
              backgroundColor: Colors.white,
              elevation: 10,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: "Dashboard"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications), label: "Notifications"),
              ],
            )),
        backgroundColor: AppColors.scaffoldColor,
        //endDrawer: const MyDrawer(),
        body: Obx(() => views[controller.currentIndex.value]),
      ),
    );
  }
}

class MyGrid extends StatelessWidget {
  final Image image;
  final String activity;
  final VoidCallback onTap;
  final Color avatarColor;
  final bool showBadge;

  const MyGrid({
    super.key,
    required this.image,
    required this.activity,
    required this.onTap,
    required this.avatarColor,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Main item stays square
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Remove default padding
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: AspectRatio(
                    // <-- force square container
                    aspectRatio: 1,
                    child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            image.color == null
                                ? ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                      AppColors
                                          .appMainDark, // <-- your Indigo color
                                      BlendMode.srcIn,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: image,
                                    ),
                                  )
                                : image,
                            if (showBadge)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                  ),
                                ),
                              ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        activity,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyGridQuick extends StatelessWidget {
  final Image image;
  final String activity;
  final VoidCallback onTap;

  const MyGridQuick({
    super.key,
    required this.image,
    required this.activity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.15,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            clipBehavior: Clip.none, // important for showing overflow
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 7,
                    child: ClipOval(
                      child: Container(
                        color: Colors.yellow.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: image,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          activity.replaceFirst(' ',
                              '\n'), // replaces the first space with a newline
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -4, // slightly outside top
                right: -4, // slightly outside right
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.appMainDark, // background of the circle
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
