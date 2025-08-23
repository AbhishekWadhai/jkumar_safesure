import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';

Widget buildFilePicker(
  PageField field,
  bool isEditable,
  DynamicFormController controller,
) {
  return Obx(() {
    List<String> fileUrls = [];
    final List<Map<String, dynamic>> selectedFiles =
        (controller.selectedFilesMap[field.headers] ?? [])
            .cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: isEditable
              ? () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: Strings.fileTypes,
                    allowMultiple: true,
                  );

                  if (result != null) {
                    final filesData = result.files.map((file) {
                      return {
                        'name': file.name,
                        'size': file.size,
                        'path': file.path,
                        'uploadStatus': 'pending', // new field
                      };
                    }).toList();

                    final updatedFiles =
                        List<Map<String, dynamic>>.from(selectedFiles)
                          ..addAll(filesData);
                    controller.selectedFilesMap[field.headers] = updatedFiles;

                    for (var file in filesData) {
                      var url = await controller.uploadFile(
                          field, file, field.endpoint ?? "");
                      fileUrls.add(url);
                    }
                    controller.formData[field.headers] = fileUrls;

                    // Start upload for each new file
                  }
                }
              : null,
          icon: const Icon(Icons.attach_file),
          label: const Text('Select Files'),
        ),
        const SizedBox(height: 10),
        if (selectedFiles.isNotEmpty)
          ...selectedFiles.map((file) => ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(file['name'] ?? ''),
                subtitle: Text(
                    '${((file['size'] ?? 0) / 1024).toStringAsFixed(2)} KB'),
                trailing: isEditable
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (file['uploadStatus'] == 'uploading')
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          if (file['uploadStatus'] == 'done')
                            const Icon(Icons.check_circle, color: Colors.green),
                          if (file['uploadStatus'] == 'error')
                            const Icon(Icons.error, color: Colors.red),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              final updatedFiles =
                                  List<Map<String, dynamic>>.from(selectedFiles)
                                    ..remove(file);
                              controller.formData[field.headers] = updatedFiles;
                            },
                          ),
                        ],
                      )
                    : null,
              )),
        if (!isEditable)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "File upload is read-only.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          'All Uploaded: ${controller.allUploaded}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: controller.allUploaded ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  });
}
