import 'package:flutter/material.dart';
import 'package:sure_safe/services/text_formatters.dart';

class DynamicDataPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> excludedKeys = ['_id', 'password', '__v'];
  final Map<String, dynamic> fieldKeys; // Map to store key-specific field names

  DynamicDataPage({required this.data, required this.fieldKeys});

  // Function to filter out excluded keys and create dynamic rows for key-value pairs
  List<Widget> _buildKeyValuePairs(Map<String, dynamic> data) {
    final filteredData = Map.fromEntries(
        data.entries.where((entry) => !excludedKeys.contains(entry.key)));

    return filteredData.entries.map((entry) {
      final formattedValue = _formatCellValue(entry.value, entry.key);

      Widget valueWidget;
      if (formattedValue.startsWith("IMAGE:")) {
        String imageUrl = formattedValue.substring(6); // Extract URL
        valueWidget = Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.broken_image),
        );
      } else {
        valueWidget = Text(
          formattedValue,
          style: const TextStyle(fontSize: 16),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
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
          }).join('; ');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildKeyValuePairs(data),
          ),
        ),
      ),
    );
  }
}
