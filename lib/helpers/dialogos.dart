import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessDialog({
  String title = "Success",
  String message = "Operation completed successfully",
  VoidCallback? onOkPressed,
}) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Get.back(); // Close the dialog
            if (onOkPressed != null) {
              onOkPressed(); // Call the passed method
            }
            Get.back(result: true); // Pop page with result
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

/// A reusable method to show confirmation dialog
Future<bool> showConfirmationDialog({
  required BuildContext context,
  String title = "Confirmation",
  String content = "Are you sure?",
  String confirmText = "Yes",
  String cancelText = "No",
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // User must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  return result ?? false; // If dismissed, return false
}
