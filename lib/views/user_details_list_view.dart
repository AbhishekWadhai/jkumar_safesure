import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/user_details_list_view_controller.dart';
import 'package:sure_safe/services/formatters.dart';
import 'package:sure_safe/widgets/helper_widgets/flexibleText.dart';


class UserDetailsListView extends StatelessWidget {
  UserDetailsListView({super.key});

  final UserDetailsListViewController controller =
      Get.put(UserDetailsListViewController());

  @override
  Widget build(BuildContext context) {
    final List args = Get.arguments;
    final String title1 = args[0];
    final String title2 = args[1];
    controller.data.assignAll(args[2]); // ✅ CORRECT
// Ensure this is a List
    print(args[2].length);
    return Scaffold(
      appBar: AppBar(
        title: Text("$title1 - $title2"),
      ),
      body: controller.data == null || controller.data.isEmpty
          ? const Center(child: Text("No data available"))
          : ListView.builder(
              itemCount: controller.data.length,
              itemBuilder: (context, index) {
                final item = controller.data[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      controller.showTileDetails(context, item);
                    },
                    title: Text(
                      capitalizeFirstLetter(_getTitleByType(title2, item)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Text(IndianDateFormatters.formatDateFromString(
                            item['date'])),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

String _getTitleByType(String title1, Map item) {
  switch (title1) {
    case 'Work Permits':
      return item['workDescription'] ?? 'No Permit Description';

    case "UaUc's":
      return item['observation'] ?? 'No Observation';
    case "Unresolved UaUc's":
      return item['observation'] ?? 'No Observation';

    case 'TBT Meetings':
      final topics = item['typeOfTopic'];
      return topics is List
          ? topics.map((e) => e['topicTypes']).join(', ')
          : 'No Topics';

    case 'Safety Inductions':
      final topics = item['typeOfTopic'];
      return topics is List
          ? topics.map((e) => e['topicTypes']).join(', ')
          : 'No Topics';

    case 'Specific Training':
      final topics = item['typeOfTopic'];
      return topics is List
          ? topics.map((e) => e['topicTypes']).join(', ')
          : 'No Topics';

    default:
      return item['date'] ?? 'No Date';
  }
}
