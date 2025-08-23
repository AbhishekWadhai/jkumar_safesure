import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/data_formatter.dart';
import 'package:sure_safe/services/translation.dart';
import 'package:sure_safe/widgets/dynamic_data_view.dart';

class DynamicTile extends StatelessWidget {
  final String endpoint;
  final Map<String, dynamic> item;
  final Map<String, dynamic> fieldKeys; // same as for details
  final Map<String, String>
      tileMapping; // e.g. { "title": "name", "subtitle": "role", "trailing": "status" }
  final VoidCallback? onTap;
  final Function(bool)? onResult;

  const DynamicTile(
      {super.key,
      required this.endpoint,
      required this.item,
      required this.fieldKeys,
      required this.tileMapping,
      this.onTap,
      this.onResult});

  @override
  Widget build(BuildContext context) {
    final formatter = DataFormatter();

    return Card(
      child: ListTile(
          title: Text(
            formatter.formatCellValue(
                item[tileMapping['title']], tileMapping['title'] ?? ''),
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: tileMapping['subtitle'] != null
              ? Text(formatter.formatCellValue(
                  item[tileMapping['subtitle']], tileMapping['subtitle']!))
              : null,
          trailing: IconButton(
            onPressed: () async {
              var result = await Get.toNamed(
                Routes.formPage,
                arguments: [endpoint, item, true],
              );

              if (result != null && onResult != null) {
                print("result======$result");
                onResult!(result); // 👈 pass the result upward
              }
            },
            icon: const Icon(Icons.edit),
          ),
          // tileMapping['trailing'] != null
          //     ? Text(formatter.formatCellValue(
          //         item[tileMapping['trailing']], tileMapping['trailing']!))
          //     : null,
          onTap: () {
            showTileDetails(context, item);
          }),
    );
  }
}

void showTileDetails(BuildContext context, Map<String, dynamic>? data) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows full height scrollable sheet
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: DynamicDataPage(
              data: data ?? {},
              fieldKeys: keysForMap,
              // optional if supported
            ),
          );
        },
      );
    },
  );
}
