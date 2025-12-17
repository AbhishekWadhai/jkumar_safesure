import 'package:flutter/material.dart';

import 'package:sure_safe/widgets/custom_form.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';

Widget buildCustomFields(DynamicFormController controller, String pageName) {
  final Map<String, dynamic> customFieldsData = controller.customFields;

  return CustomForm(
    pageFields: controller.additionalFields,
    parentFormController: controller,
    formValues: customFieldsData ?? {},
    reference: pageName,
  );
}
