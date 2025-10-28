import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';
import 'package:sure_safe/widgets/dynamic_form/build_file_picker.dart';
import 'package:sure_safe/widgets/dynamic_form/build_radio.dart';
import 'package:sure_safe/widgets/dynamic_form/calculated_field.dart';
import 'package:sure_safe/widgets/dynamic_form/checklist.dart';
import 'package:sure_safe/widgets/dynamic_form/custom_field.dart';
import 'package:sure_safe/widgets/dynamic_form/custom_text_field.dart';
import 'package:sure_safe/widgets/dynamic_form/date_time_fields.dart';
import 'package:sure_safe/widgets/dynamic_form/default_field.dart';
import 'package:sure_safe/widgets/dynamic_form/form_dropdown.dart';
import 'package:sure_safe/widgets/dynamic_form/form_extras.dart';
import 'package:sure_safe/widgets/dynamic_form/form_geotagging.dart';
import 'package:sure_safe/widgets/dynamic_form/form_image_picker.dart';
import 'package:sure_safe/widgets/dynamic_form/form_signature_pad.dart';
import 'package:sure_safe/widgets/dynamic_form/form_simple_dropdown.dart';
import 'package:sure_safe/widgets/dynamic_form/form_simple_multiselect.dart';
import 'package:sure_safe/widgets/dynamic_form/multiselect_field.dart';
import 'package:sure_safe/widgets/dynamic_form/risk_matrix.dart';
import 'package:sure_safe/widgets/dynamic_form/secondary_form.dart';

class DynamicForm extends StatefulWidget {
  final String pageName;
  final Map<String, dynamic>? initialData;
  final bool isEdit;

  DynamicForm({
    Key? key,
    required this.pageName,
    this.initialData,
    this.isEdit = false,
  }) : super(key: key);

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DynamicFormController controller = Get.find();

  @override
  void initState() {
    super.initState();
    // Load fields and form data for the page only once
    //controller.isOffline.value = ConnectivityService.to.checkConnection();
    controller.ensurePageFieldsLoaded(widget.pageName, widget.initialData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if any field has a tab property

        bool hasTabs =
            controller.pageFields.any((f) => (f.tab ?? '').isNotEmpty);

        if (hasTabs) {
          return buildTabBasedForm();
        } else {
          return buildLinearForm();
        }
      }),
    );
  }

  Widget buildLinearForm() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...controller.pageFields
                  .where((field) => controller.hasViewPermission(
                      List<String>.from(field.permissions?.view ?? [])))
                  .map((field) => Column(
                        children: [
                          buildFormField(
                            field,
                            controller.hasEditPermission(
                                field.permissions?.edit ?? []),
                            context,
                          ),
                          const SizedBox(height: 10),
                        ],
                      )),
              const SizedBox(height: 10),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabBasedForm() {
    // Group fields by tab
    final groupedFields = <String, List<PageField>>{};
    for (var field in controller.pageFields) {
      if (controller.hasViewPermission(
          List<String>.from(field.permissions?.view ?? []))) {
        final tabName = (field.tab ?? '').isNotEmpty ? field.tab! : 'General';
        groupedFields.putIfAbsent(tabName, () => []).add(field);
      }
    }

    final tabNames = groupedFields.keys.toList();

    return DefaultTabController(
      length: tabNames.length,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context);

          return Column(
            children: [
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.black,
                isScrollable: true,
                tabs: tabNames.map((name) => Tab(text: name)).toList(),
              ),
              Expanded(
                child: Form(
                    key: _formKey,
                    child: TabBarView(
                      children: List.generate(tabNames.length, (index) {
                        final isLastTab = index == tabNames.length - 1;
                        final fields = groupedFields[tabNames[index]]!;

                        return KeepAliveWrapper(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...fields.map((field) => Column(
                                      children: [
                                        buildFormField(
                                          field,
                                          controller.hasEditPermission(
                                              field.permissions?.edit ?? []),
                                          context,
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    )),
                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: isLastTab
                                      ? buildSubmitButton()
                                      : ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              tabController
                                                  .animateTo(index + 1);
                                            }
                                          },
                                          child: const Text('Next'),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          widget.isEdit
              ? controller.updateData(widget.pageName)
              : controller.submitForm(widget.pageName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please correct the errors in the form'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Text(
          widget.isEdit
              ? 'Update'
              : controller.isOnline.value
                  ? 'Submit'
                  : 'Save to Submit',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildFormField(
      PageField field, bool isEditable, BuildContext context) {
    switch (field.type) {
      case 'riskMatrix':
        return buildRiskMatrix(field, controller, widget.isEdit);
      case 'customFields':
        return buildCustomFields(controller, widget.pageName);

      case 'defaultField':
        return buildDefaultField(field, controller, widget.isEdit);

      case 'checklist':
        return buildChecklist(field, controller, isEditable);

      case 'CustomTextField':
        return buildCustomTextField(field, controller, isEditable);

      case 'calculatedField':
        return buildCalculatedField(field, controller);

      case 'editablechip':
        return buildEditableChipField(
            field, controller, widget.isEdit, isEditable);

      case 'multiselect':
        return buildMultiselectField(field, controller, isEditable, context);

      case 'imagepicker':
        return buildImagePickerField(field, controller, isEditable);

      case 'secondaryForm':
        return buildSecondaryFormField(field, controller, isEditable);

      case 'dropdown':
        return buildDropdownField(field, controller, isEditable);

      case 'simplemultiselect':
        return buildSimpleMultiSelect(field, controller, isEditable);

      case 'simpledropdown':
        return buildSimpleDropdown(field, controller);

      case 'datepicker':
        return myDatePicker(field, controller, isEditable);

      case 'timepicker':
        return myTimePicker(field, controller, isEditable);

      case 'radio':
        return buildRadio(field, isEditable, controller);

      case 'switch':
        return buildSwitch(field, controller, isEditable);
      case 'signature':
        return buildSignature(field, controller, widget.isEdit);

      case 'geolocation':
        return buildGeolocation(field, isEditable, controller);
      case 'filePicker':
        return buildFilePicker(field, isEditable, controller, widget.isEdit);
      default:
        return const Text('Unsupported field type');
    }
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
