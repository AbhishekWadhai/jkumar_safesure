import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart';

import 'package:open_filex/open_filex.dart';

Future<void> saveAndOpenPdf(Uint8List pdfBytes, String fileName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Open the file
    await OpenFilex.open(filePath);
  } catch (e) {
    print('Error saving/opening PDF: $e');
  }
}

Future<pw.MemoryImage> loadAssetImage(String path) async {
  final data = await rootBundle.load(path);
  return pw.MemoryImage(data.buffer.asUint8List());
}

Future<void> saveDynamicDataPdf(
  Map<String, dynamic> data,
  Map<String, dynamic> fieldKeys,
) async {
  final pdfDoc = pw.Document();
  final logo = await loadAssetImage('assets/rohan_logo.png');
  pdfDoc.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Header(
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 8.0),
                child: pw.Image(logo, width: 50, height: 50),
              ),
              pw.SizedBox(width: 10),
              pw.Text("Work Permit",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),
        ..._buildPdfContent(data, fieldKeys),
      ],
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final filePath =
      '$path/workpermit${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File(filePath);

  await file.writeAsBytes(await pdfDoc.save());
  print("PDF saved to: $filePath");

  // ✅ Open the PDF immediately
  final result = await OpenFilex.open(filePath);
  print("Open result: ${result.message}");
}

List<pw.Widget> _buildPdfContent(
  Map<String, dynamic> data,
  Map<String, dynamic> fieldKeys, {
  int indent = 0,
}) {
  List<pw.Widget> widgets = [];

  final excludedKeys = ['_id', 'password', '__v'];

  final filteredData = Map.fromEntries(
    data.entries.where((entry) => !excludedKeys.contains(entry.key)),
  );

  filteredData.forEach((key, value) {
    final title =
        key.replaceAllMapped(RegExp(r'(_|-)+'), (m) => ' ').toUpperCase();

    if (value is Map<String, dynamic>) {
      // Check if fieldKeys contains a subfield to show
      if (fieldKeys.containsKey(key)) {
        final subFieldName = fieldKeys[key];
        final subValue = value[subFieldName];
        widgets.add(
          pw.Padding(
            padding: pw.EdgeInsets.only(left: indent.toDouble()),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    "$title:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                    flex: 3, child: pw.Text(subValue?.toString() ?? '')),
              ],
            ),
          ),
        );
      } else {
        // No key in fieldKeys, so print full map recursively
        widgets.add(
          pw.Padding(
            padding: pw.EdgeInsets.only(left: indent.toDouble()),
            child: pw.Text("$title:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
        );
        widgets.addAll(_buildPdfContent(value, fieldKeys, indent: indent + 10));
      }
    } else if (value is List) {
      widgets.add(
        pw.Padding(
          padding: pw.EdgeInsets.only(left: indent.toDouble()),
          child: pw.Text("$title:",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
      );

      for (var item in value) {
        if (item is Map<String, dynamic>) {
          if (fieldKeys.containsKey(key)) {
            final subFieldName = fieldKeys[key];
            final subValue = item[subFieldName];
            widgets.add(
              pw.Padding(
                padding: pw.EdgeInsets.only(left: (indent + 10).toDouble()),
                child: pw.Text(subValue?.toString() ?? ''),
              ),
            );
          } else {
            widgets
                .addAll(_buildPdfContent(item, fieldKeys, indent: indent + 10));
          }
        } else {
          widgets.add(
            pw.Padding(
              padding: pw.EdgeInsets.only(left: (indent + 10).toDouble()),
              child: pw.Text(item.toString()),
            ),
          );
        }
      }
    } else {
      widgets.add(
        pw.Padding(
          padding:
              pw.EdgeInsets.only(left: indent.toDouble(), top: 4, bottom: 4),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 2,
                child: pw.Text(title,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(flex: 3, child: pw.Text(value.toString())),
            ],
          ),
        ),
      );
    }
  });

  return widgets;
}
