import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

/// Controller to hold per-field search queries for dropdowns
class DropdownSearchController extends GetxController {
  final RxMap<String, String> searchQueries = <String, String>{}.obs;

  void setSearch(String fieldHeader, String value) {
    searchQueries[fieldHeader] = value;
  }

  String getSearch(String fieldHeader) => searchQueries[fieldHeader] ?? '';
}

/// Main dropdown widget
Widget buildDropdownField(
    PageField field, DynamicFormController controller, bool isEditable) {
  // Initialize reactive field if not already
  controller.formData.putIfAbsent(field.headers, () => Rx<dynamic>(null));

  final ddCtrl =
      Get.put(DropdownSearchController(), tag: 'dropdown_search_controller');

  return FutureBuilder<List<Map<String, String>>>(
    future: controller.getDropdownData(field.endpoint ?? "", field.key ?? ""),
    builder: (context, snapshot) {
      final titleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
        ],
      );

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
          ],
        );
      }

      if (snapshot.hasError || snapshot.data == null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            const Text("Error loading data"),
            const SizedBox(height: 10),
          ],
        );
      }

      final options = snapshot.data!;
      if (options.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            const Text("No options available"),
            const SizedBox(height: 10),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          Obx(() {
            final rawValue = controller.formData[field.headers]!.value;
            final selectedId = rawValue is Map
                ? rawValue["_id"].toString()
                : rawValue?.toString();

            final match = options.firstWhere(
              (o) => o["_id"] == selectedId,
              orElse: () => {},
            );

            final label = match[field.key] ?? "Select ${field.title}";

            return InkWell(
              onTap: isEditable
                  ? () => _openDropdownSheet(
                      context, field, controller, ddCtrl, options)
                  : null,
              child: Container(
                height: 60,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child:
                            Text(label, style: const TextStyle(fontSize: 16))),
                    if (isEditable) const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
        ],
      );
    },
  );
}

/// Bottom sheet for dropdown selection
void _openDropdownSheet(
  BuildContext context,
  PageField field,
  DynamicFormController controller,
  DropdownSearchController ddCtrl,
  List<Map<String, String>> options,
) {
  showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      String query = ddCtrl.getSearch(field.headers);
      return StatefulBuilder(
        builder: (sctx, setState) {
          final filtered = query.trim().isEmpty
              ? options
              : options.where((opt) {
                  final label = (opt[field.key] ?? '').toLowerCase();
                  final id = (opt["_id"] ?? '').toLowerCase();
                  final q = query.toLowerCase();
                  return label.contains(q) || id.contains(q);
                }).toList();

          return SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top handle
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Title + Close
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Select ${field.title}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                  // Search
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: TextField(
                      controller: TextEditingController(text: query),
                      decoration:
                          InputDecoration(hintText: 'Search ${field.title}'),
                      onChanged: (val) {
                        setState(() {
                          query = val;
                          ddCtrl.setSearch(field.headers, val);
                        });
                      },
                    ),
                  ),
                  // List
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(ctx).size.height * 0.5,
                      child: filtered.isEmpty
                          ? const Center(child: Text('No options found'))
                          : ListView.separated(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final opt = filtered[i];
                                final id = opt["_id"];
                                final label = opt[field.key] ?? '';
                                final isSelected = controller
                                        .formData[field.headers]!
                                        .value is Map &&
                                    (controller.formData[field.headers]!.value
                                            as Map)["_id"] ==
                                        id;

                                return ListTile(
                                  title: Text(label),
                                  trailing: isSelected
                                      ? const Icon(Icons.check)
                                      : null,
                                  onTap: () {
                                    controller.formData[field.headers]!.value =
                                        opt;
                                    if (field.title == "Permit Types" ||
                                        field.title == "Checklist Name") {
                                      final selectedOption = options.firstWhere(
                                        (option) => option['_id'] == id,
                                        orElse: () => {},
                                      );
                                      print(
                                          "#########################${selectedOption[field.key]}");
                                      field.title == "Permit Types"
                                          ? controller.getSafetyChecklist(
                                              selectedOption[field.key] ?? '')
                                          : controller.getChecklist(
                                              selectedOption[field.key] ?? '');
                                      controller.getCustomFields(
                                          selectedOption[field.key] ?? '');
                                    }
                                    Navigator.of(ctx).pop();
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
