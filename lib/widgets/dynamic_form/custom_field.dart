import 'package:flutter/material.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/widgets/dynamic_form/custom_form.dart';

Widget buildCustomFields(DynamicFormController controller, String pageName) {
  final Map<String, dynamic> customFieldsData = controller.customFields;

  return CustomForm(
    pageFields: controller.additionalFields,
    parentFormController: controller,
    formValues: customFieldsData ?? {},
    reference: pageName,
  );
}
