import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sure_safe/services/api_services.dart';

class DynamicModuleController extends GetxController {
  final String moduleName;
  DynamicModuleController(this.moduleName);

  var config = {}.obs; // Holds module's config
  var dataList = <dynamic>[].obs; // API data
  var filteredList = <dynamic>[].obs; // Data after search/tab filter
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadConfig();
  }

  Future<void> loadConfig() async {
    final jsonString =
        await rootBundle.loadString('lib/assets/json/modules.json');
    final configList = List<Map<String, dynamic>>.from(jsonDecode(jsonString));

    config.value = configList.firstWhere(
      (c) => c['moduleName'] == moduleName,
      orElse: () => {},
    );

    if (config.isNotEmpty) {
      await fetchData();
    }
  }

  Future<void> fetchData() async {
    print("fetch data called");
    isLoading.value = true;
    dataList.value = await ApiService().getRequest(moduleName);

    applyFilters();
    isLoading.value = false;
  }

  void applyFilters() {
    var tempList = List.from(dataList);

    // Tab filter (if tabBased)
    if (config['type'] == 'tabBased') {
      final tabs = List<String>.from(config['tabs']);
      final selectedTab = tabs[selectedTabIndex.value];
      // TODO: Apply tab-specific filtering
    }

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      tempList = tempList
          .where((item) => item
              .toString()
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredList.value = tempList;
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
    applyFilters();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
    applyFilters();
  }
}
