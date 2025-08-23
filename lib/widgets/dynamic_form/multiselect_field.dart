import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

Widget buildMultiselectField(PageField field, DynamicFormController controller,
    bool isEditable, BuildContext context) {
  return FutureBuilder<List<Map<String, String>>>(
    future: controller.getDropdownData(field.endpoint ?? "", field.key ?? ""),
    builder: (BuildContext context,
        AsyncSnapshot<List<Map<String, String>>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _buildLoadingField(field.title);
      } else if (snapshot.hasError) {
        Get.snackbar(
          duration: const Duration(seconds: 30),
          snapshot.stackTrace.toString(),
          snapshot.error.toString(),
        );
        return _buildErrorField(field.title);
      } else if (snapshot.hasData) {
        final List<Map<String, String>> options = snapshot.data ?? [];
        final List<String> selectedIds =
            (controller.formData[field.headers] as List?)
                    ?.map((item) {
                      if (item is String) return item;
                      if (item is Map<String, dynamic> &&
                          item.containsKey('_id')) {
                        return item['_id']?.toString() ?? '';
                      }
                      return '';
                    })
                    .where((id) => id.isNotEmpty)
                    .toList() ??
                [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: isEditable
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This field is not editable for you'),
                          backgroundColor: Colors.grey,
                        ),
                      ),
              child: AbsorbPointer(
                absorbing: !isEditable,
                child: MultiSelectDialogField<String>(
                  validator: (value) =>
                      isEditable ? controller.validateMultiSelect(value) : null,
                  dialogHeight: 300,
                  items: options.map((option) {
                    return MultiSelectItem<String>(
                      option['_id'] ?? '',
                      option[field.key] ?? '',
                    );
                  }).toList(),
                  initialValue: selectedIds,
                  onConfirm: (selectedValues) {
                    if (isEditable) {
                      controller.updateFormData(field.headers, selectedValues);
                    }
                  },
                  title: Text("Select ${field.title}"),
                  buttonText: Text(
                    "Select ${field.title}",
                    style: TextStyle(
                        color: isEditable ? Colors.black : Colors.grey),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: isEditable ? Colors.grey : Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      } else {
        return const SizedBox();
      }
    },
  );
}

Widget _buildLoadingField(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      const CircularProgressIndicator(),
      const SizedBox(height: 10),
    ],
  );
}

Widget _buildErrorField(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      const Text("Error loading data"),
      const SizedBox(height: 10),
    ],
  );
}
