import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/module_controller.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/translation.dart';
import 'package:sure_safe/widgets/dynamic_tile.dart';

class DynamicModulePage extends StatefulWidget {
  const DynamicModulePage({super.key});

  @override
  State<DynamicModulePage> createState() => _DynamicModulePageState();
}

class _DynamicModulePageState extends State<DynamicModulePage> {
  late final String moduleName;
  late final DynamicModuleController controller;

  @override
  void initState() {
    super.initState();
    moduleName = Get.arguments?[0] ?? "";
    controller = Get.put(
      DynamicModuleController(moduleName),
      tag: moduleName, // Tag ensures unique instance per module
    );
  }

  @override
  void dispose() {
    // Optional: remove the controller when page is disposed
    if (Get.isRegistered<DynamicModuleController>(tag: moduleName)) {
      Get.delete<DynamicModuleController>(tag: moduleName);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.config.isEmpty) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(
                Routes.formPage,
                arguments: [moduleName, <String, dynamic>{}, false],
              );
            },
            child: const Icon(Icons.add),
          ),
          body: Center(child: Text("Module config not found")),
        );
      }

      final isTabBased = controller.config['type'] == 'tabBased';
      final tabs =
          isTabBased ? List<String>.from(controller.config['tabs']) : [];

      return DefaultTabController(
        length: isTabBased ? tabs.length : 1,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var result = await Get.toNamed(
                Routes.formPage,
                arguments: [moduleName, <String, dynamic>{}, false],
              );
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: "Search ${translate(moduleName)}",
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
            bottom: isTabBased
                ? TabBar(
                    onTap: controller.changeTab,
                    tabs: tabs.map((t) => Tab(text: t)).toList(),
                  )
                : null,
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.filteredList.isEmpty) {
              return const Center(child: Text("No data found"));
            }
            return ListView.builder(
              itemCount: controller.filteredList.length,
              itemBuilder: (context, index) {
                final item = controller.filteredList[index];
                return DynamicTile(
                    endpoint: moduleName,
                    item: item,
                    fieldKeys: keysForMap,
                    tileMapping: {
                      "title": controller.config['tileTitle1'] ?? '',
                      "subtitle": controller.config['tileTitle2'] ?? '',
                      "trailing": controller.config['tileTitle3'] ?? '',
                    },
                    onResult: (updatedItem) {
                      controller.fetchData();
                    });
              },
            );
          }),
        ),
      );
    });
  }
}
