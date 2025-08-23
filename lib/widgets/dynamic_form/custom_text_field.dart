import 'package:flutter/material.dart';

import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

import 'form_extras.dart';

Widget buildCustomTextField(
    PageField field, DynamicFormController controller, bool isEditable) {
  final TextEditingController textController =
      controller.getTextController(field.headers);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      TextFormField(
        validator: (value) {
          if (!isEditable) return null; // Skip validation for read-only
          return controller.validateTextField(value);
        },
        controller: textController,
        decoration: kTextFieldDecoration("Enter ${field.title}"),
        readOnly: !isEditable,
        keyboardType: field.key == "numeric" ? TextInputType.number : null,

        // Optional: Debounced save on change
        // onChanged: isEditable
        //     ? (value) {
        //         controller.debounceMap[field.headers]?.cancel();
        //         controller.debounceMap[field.headers] = Timer(
        //           const Duration(milliseconds: 2000),
        //           () => controller.updateFormData(field.headers, value),
        //         );
        //       }
        //     : null,
      ),
    ],
  );
}
