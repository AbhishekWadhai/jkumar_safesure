import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/controllers/sub_form_controller.dart';
import 'package:sure_safe/model/form_data_model.dart';
import 'package:sure_safe/widgets/subform.dart';

Widget buildSecondaryFormField(
    PageField field, DynamicFormController controller, bool isEditable) {
  // Initialize subformData if needed
  if (controller.formData[field.headers] != null &&
      controller.formData[field.headers].isNotEmpty &&
      controller.subformData.isEmpty) {
    final value = controller.formData[field.headers];

    if (value is List) {
      controller.subformData.value =
          value.whereType<Map<String, dynamic>>().toList();
    } else if (value is Map<String, dynamic>) {
      controller.subformData.value = [value];
    } else {
      controller.subformData.value = [];
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      if (isEditable)
        ListTile(
          title: const Text("Add Data"),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              var result = await Get.dialog(
                Dialog(
                  child: WillPopScope(
                    onWillPop: () async {
                      Get.delete<SubFormController>();
                      return true;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SubForm(pageName: field.headers),
                    ),
                  ),
                ),
                barrierDismissible: true,
              );

              if (result != null) {
                controller.formData.putIfAbsent(field.headers, () => []);
                controller.formData[field.headers].add(result);
                controller.subformData.value = List<Map<String, dynamic>>.from(
                    controller.formData[field.headers]);
              }
            },
          ),
        ),

      // Display List
      Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.subformData.length,
            itemBuilder: (context, index) {
              final attendee = controller.subformData[index];
              return ExpansionTile(
                key: ValueKey(attendee),
                title: Text(attendee[field.key] ?? ""),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ...attendee.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${entry.key}: ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value?.toString() ?? "N/A",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Row(
                          children: [
                            if (isEditable)
                              TextButton.icon(
                                onPressed: () async {
                                  var result = await Get.dialog(
                                    Dialog(
                                      child: WillPopScope(
                                        onWillPop: () async {
                                          Get.delete<SubFormController>();
                                          return true;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SubForm(
                                            pageName: field.headers,
                                            initialData: attendee,
                                            isEdit: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    controller.subformData[index] = result;
                                    controller.formData[field.headers] =
                                        List.from(controller.subformData);
                                  }
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text("Edit"),
                              ),
                            if (isEditable)
                              TextButton.icon(
                                onPressed: () {
                                  controller.subformData.removeAt(index);
                                  controller.formData[field.headers] =
                                      List.from(controller.subformData);
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text("Remove"),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          )),
    ],
  );
}
