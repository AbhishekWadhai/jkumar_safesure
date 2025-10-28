import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:sure_safe/app_constants/colors.dart';
import 'package:sure_safe/model/filter_model.dart';
import 'package:sure_safe/services/text_formatters.dart';
import 'package:sure_safe/widgets/dynamic_form/form_extras.dart';
import 'package:sure_safe/widgets/gradient_button.dart';
import 'package:sure_safe/widgets/module_filter_form.dart/module_filter_controller.dart';

class ModuleFilterForm extends StatefulWidget {
  final List<Filter> filterOptions;
  const ModuleFilterForm({super.key, required this.filterOptions});

  @override
  State<ModuleFilterForm> createState() => _ModuleFilterFormState();
}

class _ModuleFilterFormState extends State<ModuleFilterForm> {
  final ModuleFilterController controller = Get.put(ModuleFilterController());
  @override
  void initState() {
    super.initState();
    controller.ensurePageFieldsLoaded(widget.filterOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              ...controller.filterFields.map((field) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildFilterFields(field),
                );
              }).toList()
            ]),
          ),
          GradientButton(
              gradientColors: [AppColors.appMainDark, AppColors.appMainDark],
              borderRadius: 4,
              width: double.infinity,
              height: 35,
              onTap: () {
                printLargeJson(controller.selectedFilters);
                final result = controller.selectedFilters;
                Get.back(result: result);
              },
              text: "Apply")
        ],
      ),
    );
  }

  Widget buildFilterFields(Filter field) {
    switch (field.type) {
      case 'dropdown':
        return dropdown(field);

      case 'multiselect':
        return multiselect(field);

      case 'date':
        return myDatePicker(field, context);

      case 'time':
        return myTimePicker(field);

      case 'text':
        return textField(field);
      default:
        return SizedBox.shrink();
    }
  }

/////////////////////////dropdown////////////////////////////////////////////////////
  Obx dropdown(Filter field) {
    return Obx(() {
      final selectedValue = controller.selectedFilters[field.key];
      final processedValue =
          selectedValue is Map ? selectedValue['id'] : selectedValue;

      return FutureBuilder<List<Map<String, String>>>(
        future:
            controller.getDropdownData(field.source ?? "", field.path ?? ""),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, String>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
              ],
            );
          } else if (snapshot.hasError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("Error loading data"),
                const SizedBox(height: 10),
              ],
            );
          } else if (snapshot.hasData) {
            final List<Map<String, String>> options =
                snapshot.data?.map((item) {
                      return {
                        "_id": item["_id"]?.toString() ??
                            "", // Ensure `_id` is a string
                        field.key ?? "": item[field.path]?.toString() ?? "",
                      };
                    }).toList() ??
                    [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                DropdownButtonHideUnderline(
                  child: SizedBox(
                    width: double.infinity, // Occupy full width

                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      // validator: (value) => controller.validateDropdown(value),
                      elevation: 0, // Remove default elevation
                      value: processedValue, // Keep this as null initially
                      hint: const Text('Select an option'), // Hint text
                      items: options.map((Map<String, String> option) {
                        return DropdownMenuItem<String>(
                          value: option['_id'], // Use `_id` as value
                          child: Text(option[field.key] ??
                              ''), // Display the dynamic key (e.g., `projectName`)
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.updateFormData(field.key, newValue);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      );
    });
  }

  //////////////multiselect////////////////////////////////////
  FutureBuilder<List<Map<String, String>>> multiselect(Filter field) {
    return FutureBuilder<List<Map<String, String>>>(
      future: controller.getDropdownData(field.source ?? "", field.path ?? ""),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, String>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
            ],
          );
        } else if (snapshot.hasError) {
          Get.snackbar(
              duration: Duration(seconds: 30),
              snapshot.stackTrace.toString(),
              snapshot.error.toString());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Error loading data"),
              const SizedBox(height: 10),
            ],
          );
        } else if (snapshot.hasData) {
          final List<Map<String, String>> options = snapshot.data ?? [];
          final List<String> selectedIds =
              (controller.selectedFilters[field.key] as List?)
                      ?.map((item) {
                        if (item is String) {
                          return item; // If item is already a String, return it directly.
                        } else if (item is Map<String, dynamic> &&
                            item.containsKey('_id')) {
                          return item['_id']?.toString() ??
                              ''; // If it's a Map, extract '_id' as String.
                        } else {
                          return ''; // For any unexpected type, return an empty string.
                        }
                      })
                      .where((id) => id.isNotEmpty) // Remove any empty strings.
                      .toList() ??
                  [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Wrap MultiSelectDialogField with GestureDetector if not editable
              GestureDetector(
                onTap: () {
                  // Do nothing if not editable
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('This field is not editable for you'),
                      backgroundColor: Colors.grey,
                    ),
                  );
                },
                child: MultiSelectDialogField<String>(
                  searchable: true,
                  dialogHeight: 300,
                  items: options.map((Map<String, String> option) {
                    return MultiSelectItem<String>(
                      option['_id'] ?? "", // Use `_id` as the value
                      option[field.path] ?? '', // Display dynamic key
                    );
                  }).toList(),
                  initialValue: selectedIds,
                  onConfirm: (List<String> processedValue) {
                    // Update only if editable
                    controller.updateFormData(field.key, processedValue);
                  },
                  title: Text("Select ${field.label}"),
                  buttonText: Text(
                    "Select ${field.label}",
                    style: const TextStyle(color: Colors.black54
                        // Change color if not editable
                        ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey), // Visual indication of read-only
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
  ///////////////////////date and time Picker//////////////////////////

  Widget myDatePicker(Filter field, BuildContext context) {
    // Create a TextEditingController to store and display the picked date
    final TextEditingController dateController = TextEditingController(
      text: controller.selectedFilters[field.key]?.toString() ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: dateController,
          readOnly:
              true, // Make the TextField read-only so the user can't manually edit it
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            hintText: 'Select Date',
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              String formattedDate =
                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}"; // Format the date
              dateController.text =
                  formattedDate; // Update the TextField with the selected date
              controller.updateFormData(
                  field.key, formattedDate); // Update the form data
            }
          },
        ),
      ],
    );
  }

  Widget myTimePicker(Filter field) {
    // Create a TextEditingController to store and display the selected time
    final TextEditingController timeController = TextEditingController(
      text: controller.selectedFilters[field.key]?.toString() ?? '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: timeController,
          readOnly:
              true, // Make the TextField read-only so the user can't manually edit it
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            hintText: 'Select Time',
          ),
          onTap: () async {
            TimeOfDay? selectedTime = await showTimePicker(
              context: Get.context!,
              initialTime: TimeOfDay.now(),
            );
            if (selectedTime != null) {
              String formattedTime =
                  selectedTime.format(Get.context!); // Format the time
              timeController.text =
                  formattedTime; // Update the TextField with the selected time
              controller.updateFormData(
                  field.key, formattedTime); // Update the form data
            }
          },
        ),
      ],
    );
  }

  //////////////////////////textField///////////////////////////////
  ///
  Widget textField(Filter field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller.getTextController(field.label),
          // onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            hintText: 'Type to search',
          ),
          //validator: validator,
        ),
      ],
    );
  }
}
