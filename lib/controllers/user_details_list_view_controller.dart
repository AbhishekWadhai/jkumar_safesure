import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/services/translation.dart';
import 'package:sure_safe/widgets/dynamic_data_view.dart';

class UserDetailsListViewController extends GetxController {
  RxList<dynamic> data = [].obs;
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
}
