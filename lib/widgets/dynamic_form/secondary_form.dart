import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/controllers/sub_form_controller.dart';
import 'package:sure_safe/model/form_data_model.dart';
import 'package:sure_safe/services/text_formatters.dart';
import 'package:sure_safe/services/translation.dart';
import 'package:sure_safe/widgets/dynamic_data_view.dart';
import 'package:sure_safe/widgets/subform.dart';

Widget buildSecondaryFormField(
    PageField field, DynamicFormController controller, bool isEditable) {
  // Initialize subformData if needed
  if (controller.formData[field.headers] != null &&
      controller.formData[field.headers]?.value.isNotEmpty &&
      controller.subformData.isEmpty) {
    controller.subformData.value =
        (controller.formData[field.headers]?.value as List)
            .whereType<Map<String, dynamic>>()
            .toList();
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
                controller.formData.putIfAbsent(
                  field.headers,
                  () => Rx<dynamic>(<dynamic>[].obs),
                );

                controller.formData[field.headers]?.value.add(result);
                controller.subformData.value = List<Map<String, dynamic>>.from(
                    controller.formData[field.headers]?.value);
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

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Theme.of(context).cardColor,
                    border: Border.all(width: 1)),
                child: ExpansionTile(
                  key: ValueKey(attendee),
                  // tilePadding:
                  //     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  childrenPadding: const EdgeInsets.all(4),
                  iconColor: Theme.of(context).primaryColor,
                  title: Text(
                    attendee[field.key]?.toString() ?? "Details",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Data View Card
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DynamicDataPage(
                            data: attendee,
                            fieldKeys: keysForMap,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ✅ Action Buttons
                        if (isEditable)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    var result = await Get.dialog(
                                      Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: WillPopScope(
                                          onWillPop: () async {
                                            Get.delete<SubFormController>();
                                            return true;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
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
                                      controller
                                              .formData[field.headers]?.value =
                                          List.from(controller.subformData);
                                    }
                                  },
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text("Edit"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    controller.subformData.removeAt(index);
                                    controller.formData[field.headers]?.value =
                                        List.from(controller.subformData);
                                  },
                                  icon: const Icon(Icons.delete, size: 18),
                                  label: const Text("Remove"),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
    ],
  );
}
