import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/helpers/sixed_boxes.dart';
import 'package:sure_safe/model/form_data_model.dart';

Widget buildSimpleDropdown(PageField field, DynamicFormController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      sb10,
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Obx(() {
            final selectedValue = controller.formData[field.headers] as String?;
            final options = [...(field.options ?? [])];

            // If selectedValue exists but not in options, add it temporarily
            if (selectedValue != null && !options.contains(selectedValue)) {
              options.insert(
                  0, selectedValue); // put at top (or end if you prefer)
            }

            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: InputBorder.none),
              validator: (value) => controller.validateDropdown(value),
              elevation: 0,
              value: selectedValue,
              hint: const Text('Select an option'),
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.updateDropdownSelection(field.headers, newValue);
                }
              },
            );
          }),
        ),
      ),
    ],
  );
}
