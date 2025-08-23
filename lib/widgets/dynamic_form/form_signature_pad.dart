import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:signature/signature.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

Column buildSignature(
    PageField field, DynamicFormController controller, bool isEdit) {
  bool isOnline = controller.isOnline.value;
  String? signatureUrl = controller.formData[field.headers];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        field.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),

      isEdit
          ? (signatureUrl != null && signatureUrl.isNotEmpty
              ? Image.network(
                  signatureUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : const Text("No signature available."))
          : Signature(
              controller: controller.getSignatureController(field.headers),
              height: 200,
              backgroundColor: Colors.grey[200]!,
            ),

      if (!isEdit)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.signatureControllers[field.headers]?.clear();
              },
              child: const Text("Clear"),
            ),
            ElevatedButton(
              onPressed: () async {
                final sigController =
                    controller.signatureControllers[field.headers];
                if (sigController == null) return;

                if (!isOnline) {
                  // 🌐 Store locally
                  final bytes = await sigController.toPngBytes();
                  if (bytes != null) {
                    final localPath = await controller.saveSignatureLocally(
                        field.headers, bytes);
                    controller.updateFormData(field.headers, localPath);
                    controller.imageErrors[field.headers] = null;

                    // Optional: mark as offline signature for future sync
                    controller.queueOfflineSignatureUpload(
                        field.headers, localPath);
                  } else {
                    controller.imageErrors[field.headers] =
                        "Could not capture signature.";
                  }
                } else {
                  // 🌍 Upload online
                  String? imageUrl = await controller.saveSignature(
                      field.headers, field.endpoint ?? "");
                  if (imageUrl != null) {
                    controller.updateFormData(field.headers, imageUrl);
                    controller.imageErrors[field.headers] = null;
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),

      // Error message display
      Obx(() {
        final error = controller.imageErrors[field.headers];
        return error != null
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : const SizedBox.shrink();
      }),
    ],
  );
}
