import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

Widget buildRadio(
    PageField field, bool isEditable, DynamicFormController controller) {
  return Obx(() {
    final selectedValue = controller.formData[field.headers]?.toString();
    final List<String> options = field.options!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: options.map((option) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedValue,
                onChanged: isEditable // Check if it's editable
                    ? (String? newValue) {
                        if (newValue != null) {
                          controller.updateRadioSelection(
                              field.headers, newValue);
                        }
                      }
                    : null, // Disable onChanged if not editable
                // Optionally, change the appearance of disabled tiles
                activeColor: isEditable ? null : Colors.grey,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  });
}
