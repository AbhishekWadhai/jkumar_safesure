import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';
import '../../helpers/sixed_boxes.dart';
import '../helper_widgets/risk_color_switch.dart';

Widget buildRiskMatrix(
    PageField field, DynamicFormController controller, bool isEdit) {
  print("-----------${controller.formData[field.headers]}---risk");
  final fieldData = controller.formData[field.headers];
  controller.riskLevel.value =
      fieldData != null ? fieldData[field.key] : "No Values Selected";
  final Map<String, int> severityOptions = {
    // '-': 0,
    'Low': 1,
    'Medium': 2,
    'High': 3,
    'Critical': 4,
  };

  final Map<String, int> likelihoodOptions = {
    //'-': 0,
    'Rare': 1,
    'Possible': 2,
    'Likely': 3,
    'Almost Certain': 4,
  };

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Accident Severity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                sb10,
                Obx(() => InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: controller.severity.value,
                          onChanged: (val) {
                            controller.severity.value = val ?? 0;
                            controller.calculateRiskLevel();
                          },
                          items: severityOptions.entries
                              .map((entry) => DropdownMenuItem<int>(
                                    value: entry.value,
                                    child: Text(entry.key),
                                  ))
                              .toList(),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          sb20,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Accident Likelihood',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                sb10,
                Obx(() => InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: controller.likelihood.value,
                          onChanged: (val) {
                            controller.likelihood.value = val ?? 0;
                            controller.calculateRiskLevel();
                          },
                          items: likelihoodOptions.entries
                              .map((entry) => DropdownMenuItem<int>(
                                    value: entry.value,
                                    child: Text(entry.key),
                                  ))
                              .toList(),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Obx(() => Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Risk Level: ${controller.riskLevel.value}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getRiskColor(controller.riskLevel.value),
                          ),
                        ),
                        if (controller.timelineHours.value > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              "Alert Window: ${controller.timelineHours.value} hour(s)",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        if (controller.deadlineText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Complete action by: ${controller.deadlineText.value}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.matrixError['riskValue'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    controller.matrixError['riskValue']!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
            ],
          )),
      sb32
    ],
  );
}
