import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';
import 'package:sure_safe/views/additional_views/image_view_page.dart';

import '../../views/additional_views/browser_view.dart';

Widget buildFilePicker(
  PageField field,
  bool isEditable,
  DynamicFormController controller,
  bool isEdit,
) {
  String _getExtension(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      if (!path.contains('.')) return '';
      return path.split('.').last;
    } catch (_) {
      return '';
    }
  }

  bool checkImageUrl(String originalUrl) {
    // final encoded = Uri.encodeFull(originalUrl);
    final ext = _getExtension(originalUrl).toLowerCase();

    const imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'};

    if (imageExts.contains(ext)) {
      // return original so WebView/Image can load the raw image
      return true;
    } else {
      return false;
    }
  }

  return Obx(() {
    // currently selected (pending/new) files in the UI
    final List<Map<String, dynamic>> selectedFiles =
        (controller.selectedFilesMap[field.headers] ?? [])
            .cast<Map<String, dynamic>>();

    // existing uploaded URLs stored in formData (could be List<String> or String)
    final dynamic existing = controller.formData[field.headers];
    final List<String> uploadedUrls = [];

    if (existing != null) {
      if (existing is List) {
        for (var v in existing) {
          if (v != null) uploadedUrls.add(v.toString());
        }
      } else if (existing is String && existing.isNotEmpty) {
        // sometimes server returns a single string url
        uploadedUrls.add(existing);
      }
    }

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
                        'uploadStatus': 'pending',
                      };
                    }).toList();

                    final updatedFiles =
                        List<Map<String, dynamic>>.from(selectedFiles)
                          ..addAll(filesData);
                    controller.selectedFilesMap[field.headers] = updatedFiles;

                    // upload each and collect returned URLs
                    List<String> newUrls = [];
                    for (var file in filesData) {
                      // mark uploading
                      file['uploadStatus'] = 'uploading';
                      controller.selectedFilesMap[field.headers] =
                          List<Map<String, dynamic>>.from(selectedFiles)
                            ..addAll(filesData);

                      try {
                        var url = await controller.uploadFile(
                            field, file, field.endpoint ?? "");
                        newUrls.add(url);
                        file['uploadStatus'] = 'done';
                      } catch (_) {
                        file['uploadStatus'] = 'error';
                      }
                      // update map so UI reflects status change
                      controller.selectedFilesMap[field.headers] =
                          List<Map<String, dynamic>>.from(
                              controller.selectedFilesMap[field.headers] ?? []);
                    }

                    // merge existing uploaded urls (if any) and update formData
                    final mergedUrls = <String>[];
                    mergedUrls.addAll(uploadedUrls);
                    mergedUrls.addAll(newUrls);
                    controller.formData[field.headers] = mergedUrls;
                  }
                }
              : null,
          icon: const Icon(Icons.attach_file),
          label: const Text('Select Files'),
        ),
        const SizedBox(height: 10),

        // If we are in edit mode, show already-uploaded URLs as clickable tiles
        if (isEdit && uploadedUrls.isNotEmpty) ...[
          const Text('Previously uploaded files:',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          ...uploadedUrls.map((url) {
            return ListTile(
              leading: const Icon(Icons.cloud_done),
              title: Text(
                Uri.tryParse(url)?.pathSegments.isNotEmpty == true
                    ? Uri.parse(url).pathSegments.last
                    : url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () {
                // open http(s) urls in BrowserView; otherwise open with ImageViewPage
                if (checkImageUrl(url)) {
                  Get.bottomSheet(
                      SizedBox(
                          height: 700, child: ImageViewPage(imageUrl: url)),
                      isScrollControlled: true);
                } else {
                  Get.to(() => BrowserBottomSheetLauncher(url: url));
                }
              },
              trailing: isEditable
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // remove this url from formData
                        final remaining = List<String>.from(uploadedUrls)
                          ..remove(url);
                        controller.formData[field.headers] = remaining;
                      },
                    )
                  : null,
            );
          }).toList(),
          const SizedBox(height: 10),
        ],

        // show newly selected (not-yet-uploaded / upload-status) files
        if (selectedFiles.isNotEmpty)
          ...selectedFiles.map((file) {
            return ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text(file['name'] ?? ''),
              subtitle:
                  Text('${((file['size'] ?? 0) / 1024).toStringAsFixed(2)} KB'),
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
                            controller.selectedFilesMap[field.headers] =
                                updatedFiles;
                            // if you also keep formData in sync for these intermediate files,
                            // remove it from formData as well (depends on your design)
                          },
                        ),
                      ],
                    )
                  : null,
            );
          }).toList(),

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
