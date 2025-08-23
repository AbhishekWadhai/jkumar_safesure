import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

Widget buildSimpleDropdown(PageField field, DynamicFormController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // Border radius
          border: Border.all(color: Colors.grey, width: 1.0), // Optional border
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Obx(() {
            // Safely get the selected value from formData
            final selectedValue = controller.formData[field.headers] as String?;

            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: InputBorder.none),
              validator: (value) => controller.validateDropdown(value),
              elevation: 0, // Remove default elevation
              value: selectedValue, // Set the selected value
              hint: const Text('Select an option'), // Hint text
              items: (field.options != null)
                  ? field.options!.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option ?? ''), // Display option text
                      );
                    }).toList()
                  : [], // Return an empty list if `field.options` is null

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
