import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/text_formatters.dart';
import 'package:sure_safe/views/additional_views/image_view_page.dart';

class DynamicDataPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> excludedKeys = ['_id', 'password', '__v', 'editAllowed'];
  final Map<String, dynamic> fieldKeys; // Map to store key-specific field names

  DynamicDataPage({required this.data, required this.fieldKeys});

  // Function to filter out excluded keys and create dynamic rows for key-value pairs
  List<Widget> _buildKeyValuePairs(Map<String, dynamic> data) {
    final filteredData = Map.fromEntries(
        data.entries.where((entry) => !excludedKeys.contains(entry.key)));

    return filteredData.entries.map((entry) {
      bool isChecklist = false;
      final formattedValue = _formatCellValue(entry.value, entry.key);

      Widget valueWidget;
      if (formattedValue.startsWith("CHECKLIST:")) {
        valueWidget = _buildCheckListTable(data[entry.key]);
        isChecklist = true;
      } else if (formattedValue.startsWith("NESTED:")) {
        valueWidget = _buildNested({"data": data[entry.key]});
        isChecklist = true;
        //valueWidget = _buildCheckListTable(data[entry.key]);
      } else if (formattedValue.startsWith("IMAGE:")) {
        String imageUrl = formattedValue.substring(6); // Extract URL
        valueWidget = GestureDetector(
          onTap: () => Get.to(ImageViewPage(imageUrl: imageUrl)),
          child: Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.broken_image),
          ),
        );
      } else {
        valueWidget = Text(
          formattedValue,
          style: const TextStyle(fontSize: 16),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: isChecklist
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TextFormatters().toTitleCase(entry.key),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  valueWidget,
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      TextFormatters().toTitleCase(entry.key),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Spacer(),
                  Expanded(flex: 2, child: valueWidget),
                ],
              ),
      );
    }).toList();
  }

  // Helper function to format cell value based on its type
  String _formatCellValue(dynamic value, String key) {
    if (value != null) {
      // ---------- 🟢 ADD THIS BLOCK HERE ----------
      if (value is List && value.isNotEmpty && value.first is Map) {
        //final firstMap = value.first as Map;

        if (_isChecklist(value)) {
          return "CHECKLIST:$key"; // Special signal for UI rendering
        } else if (hasMapAndStringInFirstElement(value)) {
          return "NESTED:$key";
        } else {
          print("-----------------------------bjdsk");
        }
      }
      if (value is String) {
        // Check if the value is an image URL
        if (_isImageUrl(value)) {
          return "IMAGE:$value"; // Placeholder for image display logic
        }

        // Try parsing as DateTime
        try {
          DateTime parsedDate = DateTime.parse(value);
          return _formatDate(parsedDate);
        } catch (e) {
          return value; // Return original string if not a date
        }
      }

      // Check if the value is a list of maps
      if (value is List) {
        if (value.isEmpty) return '-'; // handle empty list gracefully

        if (value.first is Map) {
          return value.map((item) {
            if (item is Map) {
              if (fieldKeys.containsKey(key)) {
                String fieldName = fieldKeys[key]!;
                return item[fieldName]?.toString() ?? '';
              }
              return item.values.join(', ');
            }
            return '';
          }).join(' | ');
        }

        // If it's a list of primitives like List<String> or List<int>
        return value.map((e) => e.toString()).join(', ');
      }

      // Check if the field exists in fieldKeys
      if (fieldKeys.containsKey(key)) {
        String fieldName = fieldKeys[key]!;
        return value[fieldName]?.toString() ?? '';
      } else {
        return value.toString();
      }
    } else {
      return '';
    }
  }

// Helper function to check if a string is an image URL
  bool _isImageUrl(String url) {
    if (url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.gif') ||
        url.toLowerCase().endsWith('.bmp') ||
        url.toLowerCase().endsWith('.webp')) {
      return true;
    }

    // Check for Google Drive file URLs
    return url.contains("drive.google.com");
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  bool _isChecklist(List list) {
    if (list.isEmpty || list.first is! Map) return false;

    final map = list.first as Map;

    // Possible question keys
    const questionKeys = ["CheckPoints", "question", "title", "description"];

    // Possible response keys
    const responseKeys = ["response", "answer", "status", "value"];

    // Check if at least one question & one response key exists
    bool hasQuestion = map.keys.any((k) => questionKeys.contains(k));
    bool hasResponse = map.keys.any((k) => responseKeys.contains(k));

    return hasQuestion && hasResponse;
  }

  bool hasMapAndStringInFirstElement(List list) {
    if (list.isEmpty || list.first is! Map) return false;

    final map = list.first as Map;

    bool hasNestedMap = false;
    bool hasString = false;

    for (final value in map.values) {
      if (value is Map) hasNestedMap = true;
      if (value is String) hasString = true;

      // Early exit for performance
      if (hasNestedMap && hasString) return true;
    }

    return false;
  }

  // Change the parameter name for clarity
  Widget _buildNested(Map<String, dynamic> wrapperMap) {
    final List<dynamic> nestedList = wrapperMap["data"] as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // ✅ important
      children: [
        ...nestedList.map((item) {
          //compare this with the working of .map and for loop
          print("count----------");
          if (item is Map<String, dynamic>) {
            print("count++++++++");
            return Container(
              margin: const EdgeInsets.only(top: 12, bottom: 12.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
               
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: DynamicDataPage(
                data: item,
                fieldKeys: fieldKeys,
              ),
            );
          }

          return const SizedBox.shrink();
        }).toList(),
      ],
    );
  }

  Widget _buildCheckListTable(List<dynamic> list) {
    // printLargeJson(list);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(top: 8),
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1),
        },
        children: [
          // Header Row
          const TableRow(
            decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Check Point",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Response",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),

          // Dynamic rows
          ...list.map((item) {
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item["CheckPoints"] ?? item['question']),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item["response"] ?? "-"),
                ),
              ],
            );
          }).toList()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildKeyValuePairs(data),
        ),
      ),
    );
  }
}
