import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';


Widget buildDropdownField(
    PageField field, DynamicFormController controller, bool isEditable) {
  return Obx(() {
    final selectedValue = (controller.formData[field.headers] is Map)
        ? controller.formData[field.headers]["_id"].toString()
        : controller.formData[field.headers]?.toString();

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

        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              const Text("Error loading data"),
              const SizedBox(height: 10),
            ],
          );
        }

        final options = snapshot.data ?? [];

        // Ensure selectedValue is valid (i.e., exactly one match)
        final matchingItems =
            options.where((option) => option['_id'] == selectedValue).toList();
        final safeSelectedValue =
            matchingItems.length == 1 ? selectedValue : null;

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

        if (isEditable) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              DropdownButtonHideUnderline(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      validator: (value) => isEditable
                          ? controller.validateDropdown(value)
                          : null,
                      value: safeSelectedValue,
                      hint: const Text('Select an option'),
                      elevation: 0,
                      items: options.map((option) {
                        return DropdownMenuItem<String>(
                          value: option['_id'],
                          child: Text(option[field.key] ?? ''),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          controller.updateDropdownSelection(
                              field.headers, newValue);

                          if (field.title == "Permit Types") {
                            final selectedOption = options.firstWhere(
                              (option) => option['_id'] == newValue,
                              orElse: () => {},
                            );
                            controller
                                .getChecklist(selectedOption[field.key] ?? '');
                            controller.getCustomFields(
                                selectedOption[field.key] ?? '');
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        }

        // Read-only display (not editable)
        final displayText = options.firstWhere(
              (option) => option['_id'] == selectedValue,
              orElse: () => {field.key ?? "": "Action not available for user"},
            )[field.key] ??
            'Action not available for user';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget,
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Text(displayText, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  });
}
