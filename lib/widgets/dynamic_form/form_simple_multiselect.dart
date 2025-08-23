import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';
Widget buildSimpleMultiSelect(
    PageField field, DynamicFormController controller, bool isEditable) {
  return Obx(() {
    final List<String> initialSelectedValues =
        (controller.formData[field.headers] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        MultiSelectDialogField<String>(
          validator: (value) {
            if (!isEditable) return null;
            return controller.validateMultiSelect(value);
          },
          dialogHeight: 300,
          items: (field.options ?? []).map((option) {
            return MultiSelectItem<String>(option, option);
          }).toList(),
          initialValue: initialSelectedValues,
          onConfirm: (List<String> selectedValues) {
            controller.updateFormData(field.headers, selectedValues);
          },
          title: Text("Select ${field.title}"),
          buttonText: Text("Select ${field.title}", style: const TextStyle()),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  });
}
