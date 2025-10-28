import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

Widget buildDropdownField(
    PageField field, DynamicFormController controller, bool isEditable) {
  // ensure a single instance per page (will reuse if already put)
  final ddCtrl =
      Get.put(DropdownSearchController(), tag: 'dropdown_search_controller');

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
          // Observe ddCtrl.searchQueries for this field so UI rebuilds when query changes
          return Obx(() {
            final query = ddCtrl.getSearch(field.headers);
            final filteredOptions = query.trim().isEmpty
                ? options
                : options.where((opt) {
                    final label = (opt[field.key] ?? '').toLowerCase();
                    final id = (opt['_id'] ?? '').toLowerCase();
                    final q = query.toLowerCase();
                    return label.contains(q) || id.contains(q);
                  }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                // Search box (uses controller kept in DropdownSearchController)

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
                      child: // Replace the DropdownButtonFormField<String>(...) block with this FormField-based picker
                          FormField<String>(
                        initialValue: safeSelectedValue,
                        validator: (value) => isEditable
                            ? controller.validateDropdown(value)
                            : null,
                        builder: (FormFieldState<String> state) {
                          // Helper to get display text from id
                          String _displayForId(String? id) {
                            return options.firstWhere(
                                  (opt) => opt['_id'] == id,
                                  orElse: () =>
                                      {field.key ?? "": "Select Option ${field.title}"},
                                )[field.key] ??
                                'Select Option ${field.key}';
                          }

                          return InkWell(
                            onTap: () async {
                              // open a bottom sheet with search + list
                              await showModalBottomSheet<String>(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.6,
                                ),
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                builder: (ctx) {
                                  String query = '';
                                  List<Map<String, String>> filtered =
                                      List.from(options);

                                  return StatefulBuilder(
                                    builder: (sctx, setState) {
                                      // compute filtered
                                      filtered = query.trim().isEmpty
                                          ? options
                                          : options.where((opt) {
                                              final label =
                                                  (opt[field.key] ?? '')
                                                      .toLowerCase();
                                              final id = (opt['_id'] ?? '')
                                                  .toLowerCase();
                                              final q = query.toLowerCase();
                                              return label.contains(q) ||
                                                  id.contains(q);
                                            }).toList();

                                      return SafeArea(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(ctx)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Top handle + title
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Container(
                                                  height: 4,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Select ${field.title}',
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          Navigator.of(ctx)
                                                              .pop(),
                                                      icon: Icon(Icons.close),
                                                    )
                                                  ],
                                                ),
                                              ),

                                              // Search field inside popup
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8),
                                                child: TextField(
                                                  //autofocus: true,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Search ${field.title}',
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 12,
                                                            horizontal: 12),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                  ),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      query = val;
                                                    });
                                                  },
                                                ),
                                              ),

                                              // List
                                              Flexible(
                                                // allow the sheet to grow but not exceed screen height
                                                child: SizedBox(
                                                  height: MediaQuery.of(ctx)
                                                          .size
                                                          .height *
                                                      0.6,
                                                  child: filtered.isEmpty
                                                      ? Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Text(
                                                                'No options found'),
                                                          ),
                                                        )
                                                      : ListView.separated(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              filtered.length,
                                                          separatorBuilder: (_,
                                                                  __) =>
                                                              Divider(
                                                                  height: 1),
                                                          itemBuilder:
                                                              (context, i) {
                                                            final opt =
                                                                filtered[i];
                                                            final id =
                                                                opt['_id'];
                                                            final label = opt[
                                                                    field
                                                                        .key] ??
                                                                '';
                                                            final selected =
                                                                id ==
                                                                    state.value;
                                                            return ListTile(
                                                              title:
                                                                  Text(label),
                                                              trailing: selected
                                                                  ? Icon(Icons
                                                                      .check)
                                                                  : null,
                                                              onTap: () {
                                                                // update formfield state and your controller
                                                                state.didChange(
                                                                    id);
                                                                controller
                                                                    .updateDropdownSelection(
                                                                        field
                                                                            .headers,
                                                                        id ??
                                                                            "");

                                                                if (field
                                                                        .title ==
                                                                    "Permit Types") {
                                                                  final selectedOption =
                                                                      options
                                                                          .firstWhere(
                                                                    (option) =>
                                                                        option[
                                                                            '_id'] ==
                                                                        id,
                                                                    orElse:
                                                                        () =>
                                                                            {},
                                                                  );
                                                                  controller.getChecklist(
                                                                      selectedOption[
                                                                              field.key] ??
                                                                          '');
                                                                  controller.getCustomFields(
                                                                      selectedOption[
                                                                              field.key] ??
                                                                          '');
                                                                }

                                                                Navigator.of(
                                                                        ctx)
                                                                    .pop(id);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );

                              // trigger validation UI if needed
                              state.validate();
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorText: state.errorText,
                              ),
                              // shows current selected label and dropdown icon
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _displayForId(
                                          state.value ?? safeSelectedValue),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          });
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

class DropdownSearchController extends GetxController {
  // per-field text controllers (so controllers aren't recreated each build)
  final Map<String, TextEditingController> _textCtrls = {};

  // per-field reactive search queries
  final RxMap<String, String> searchQueries = <String, String>{}.obs;

  /// Get or create a TextEditingController for a field header
  TextEditingController getController(String fieldHeader) {
    if (!_textCtrls.containsKey(fieldHeader)) {
      _textCtrls[fieldHeader] = TextEditingController();
      // keep controller text synced with searchQueries (optional)
      _textCtrls[fieldHeader]!.addListener(() {
        searchQueries[fieldHeader] = _textCtrls[fieldHeader]!.text;
      });
    }
    return _textCtrls[fieldHeader]!;
  }

  /// Set the search programmatically
  void setSearch(String fieldHeader, String value) {
    searchQueries[fieldHeader] = value;
    // keep TextEditingController in sync if exists
    if (_textCtrls.containsKey(fieldHeader) &&
        _textCtrls[fieldHeader]!.text != value) {
      _textCtrls[fieldHeader]!.text = value;
      // move cursor to end
      _textCtrls[fieldHeader]!.selection = TextSelection.fromPosition(
        TextPosition(offset: _textCtrls[fieldHeader]!.text.length),
      );
    }
  }

  /// Get current query (returns empty string if none)
  String getSearch(String fieldHeader) => searchQueries[fieldHeader] ?? '';

  @override
  void onClose() {
    // dispose all text controllers
    for (final c in _textCtrls.values) {
      c.dispose();
    }
    _textCtrls.clear();
    searchQueries.clear();
    super.onClose();
  }
}
