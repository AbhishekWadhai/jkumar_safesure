import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/text_formatters.dart';
import 'package:sure_safe/views/additional_views/image_view_page.dart';

class DynamicDataPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> excludedKeys = [
    'id',
    '_id',
    'password',
    '__v',
    "editAllowed"
  ];
  final Map<String, dynamic> fieldKeys; // Map to store key-specific field names

  DynamicDataPage({required this.data, required this.fieldKeys});

  // --- Build key-value pairs; needs context to push pages
  List<Widget> _buildKeyValuePairs(
      BuildContext context, Map<String, dynamic> data) {
    final filteredData = Map.fromEntries(
      data.entries.where((entry) => !excludedKeys.contains(entry.key)),
    );

    return filteredData.entries.map((entry) {
      final key = entry.key;
      final value = entry.value;

      // If the value is a list of image urls, build a thumbnail row
      if (_isListOfImageUrls(value)) {
        final List<String> urls =
            List<String>.from(value.map((e) => e.toString()));
        final thumbRow = _buildImageThumbnailRow(context, urls, key);
        return _kvRow(key, thumbRow);
      }

      // If the value is a list of maps and fieldKeys tells which field has url
      if (value is List &&
          value.isNotEmpty &&
          value.first is Map &&
          fieldKeys.containsKey(key)) {
        final String imageFieldName = fieldKeys[key]!.toString();
        final extractedUrls = value
            .map((e) {
              if (e is Map) return e[imageFieldName]?.toString();
              return null;
            })
            .where((u) => u != null && _isImageUrl(u!))
            .cast<String>()
            .toList();

        if (extractedUrls.isNotEmpty) {
          final thumbRow = _buildImageThumbnailRow(context, extractedUrls, key);
          return _kvRow(key, thumbRow);
        }
      }

      // If the value is a single image url
      final formattedValue = _formatCellValue(value, key);
      Widget valueWidget;
      if (formattedValue.startsWith("IMAGE:")) {
        String imageUrl = formattedValue.substring(6);
        valueWidget = _buildSingleImage(context, imageUrl, key);
      } else {
        valueWidget = Text(
          formattedValue,
          style: const TextStyle(fontSize: 16),
        );
      }

      return _kvRow(key, valueWidget);
    }).toList();
  }

  // Helper to build a row for key + widget
  Widget _kvRow(String key, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  TextFormatters().toTitleCase(key),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(flex: 1, child: valueWidget),
            ],
          ),
          Divider(
            color: Colors.black26,
          )
        ],
      ),
    );
  }

  // Build a tappable single image thumbnail with Hero
  Widget _buildSingleImage(
      BuildContext context, String imageUrl, String tagBase) {
    final tag = '$tagBase-$imageUrl';
    return GestureDetector(
      onTap: () {
        Get.to(ImageViewPage(imageUrl: imageUrl));
      },
      child: Hero(
        tag: tag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }

  // Build a horizontal thumbnail strip for a list of image URLs
  Widget _buildImageThumbnailRow(
      BuildContext context, List<String> urls, String tagBase) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final url = urls[index];
          final tag = '$tagBase-$index-$url';

          // 🟢 Case 1: Image
          if (_isImageUrl(url)) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ImageGalleryPage(
                      urls: urls.where(_isImageUrl).toList(), // only images
                      initialIndex:
                          urls.where(_isImageUrl).toList().indexOf(url),
                      tagBase: tagBase,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: tag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
            );
          }

          // 🟠 Case 2: Document
          else if (_isDocumentUrl(url)) {
            final fileName = url.split('/').last;
            return GestureDetector(
              onTap: () {
                // Open in external viewer
                // (for in-app PDF, use url_launcher or a pdf viewer package)
                debugPrint('Open document: $url');
              },
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.insert_drive_file,
                        size: 36, color: Colors.blueGrey.shade700),
                    const SizedBox(height: 6),
                    Text(
                      fileName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }

          // 🔴 Case 3: Unknown file type
          else {
            final fileName = url.split('/').last;
            return Container(
              width: 100,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.help_outline, size: 36, color: Colors.grey),
                  const SizedBox(height: 6),
                  Text(
                    fileName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
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
                String fieldName = fieldKeys[key]!.toString();
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
        String fieldName = fieldKeys[key]!.toString();
        return value[fieldName]?.toString() ?? '';
      } else {
        return value.toString();
      }
    } else {
      return '';
    }
  }

  bool _isDocumentUrl(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.pdf') ||
        u.endsWith('.doc') ||
        u.endsWith('.docx') ||
        u.endsWith('.xls') ||
        u.endsWith('.xlsx') ||
        u.endsWith('.ppt') ||
        u.endsWith('.pptx');
  }

  // Helper function to check if a string is an image URL
  bool _isImageUrl(String url) {
    final u = url.toLowerCase();
    if (u.endsWith('.png') ||
        u.endsWith('.jpg') ||
        u.endsWith('.jpeg') ||
        u.endsWith('.gif') ||
        u.endsWith('.bmp') ||
        u.endsWith('.webp')) {
      return true;
    }
    // Check for Google Drive file URLs or other heuristics
    return url.contains("drive.google.com") ||
        url.contains("cdn") ||
        url.contains("https://");
  }

  // Check if value is a list of image URLs
  bool _isListOfImageUrls(dynamic value) {
    if (value is List && value.isNotEmpty) {
      // All elements should be strings and image urls
      return value.every((e) => e is String && _isImageUrl(e.toString()));
    }
    return false;
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
            children: _buildKeyValuePairs(context, data),
          ),
        ),
      ),
    );
  }
}


class ImageGalleryPage extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  final String tagBase;

  const ImageGalleryPage(
      {required this.urls,
      this.initialIndex = 0,
      required this.tagBase,
      Key? key})
      : super(key: key);

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  late PageController _pageController;
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('${current + 1} / ${widget.urls.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.urls.length,
        onPageChanged: (i) => setState(() => current = i),
        itemBuilder: (context, index) {
          final url = widget.urls[index];
          final tag = '${widget.tagBase}-$index-$url';
          return SafeArea(
            child: Center(
              child: Hero(
                tag: tag,
                child: InteractiveViewer(
                  maxScale: 4.0,
                  minScale: 0.5,
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
