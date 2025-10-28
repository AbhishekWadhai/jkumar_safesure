import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/model/filter_model.dart';

class ModuleFilterController extends GetxController {
  RxMap<String, dynamic> selectedFilters = <String, dynamic>{}.obs;
  RxList<Filter> filterFields = <Filter>[].obs;
  final Map<String, TextEditingController> textControllers = {};

  Future<void> ensurePageFieldsLoaded(List<Filter> filterList) async {
    filterFields.value = filterList;
  }

  void updateFormData(String key, dynamic value) {
    selectedFilters[key] = value;
    update();
  }

  TextEditingController getTextController(String fieldHeader) {
    if (!textControllers.containsKey(fieldHeader)) {
      // Create a new controller if it doesn't exist
      textControllers[fieldHeader] = TextEditingController(
        text: selectedFilters[fieldHeader]?.toString() ?? '',
      );
    }
    return textControllers[fieldHeader]!;
  }

  Future<List<Map<String, String>>> getDropdownData(
      String endpoint, String key) async {
    final dropdownResult = Strings.endpointToList[endpoint] ?? [];
    return dropdownResult
        .map<Map<String, String>>((element) => {
              '_id': element['_id'].toString(),
              key: element[key].toString(),
            })
        .toList();
  }
}
