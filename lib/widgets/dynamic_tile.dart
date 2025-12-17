import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sure_safe/app_constants/app_strings.dart';
import 'package:sure_safe/app_constants/colors.dart';
import 'package:sure_safe/controllers/module_controller.dart';
import 'package:sure_safe/helpers/dialogos.dart';
import 'package:sure_safe/helpers/sixed_boxes.dart';
import 'package:sure_safe/routes/routes_string.dart';
import 'package:sure_safe/services/data_formatter.dart';
import 'package:sure_safe/services/download_service.dart';
import 'package:sure_safe/services/formatters.dart';
import 'package:sure_safe/services/pdf_generator/pdf_generator.dart';
import 'package:sure_safe/services/translation.dart';
import 'package:sure_safe/views/additional_views/browser_view.dart';
import 'package:sure_safe/widgets/custom_alert_dialog.dart';
import 'package:sure_safe/widgets/dynamic_data_view.dart';
import 'package:sure_safe/widgets/helper_widgets/risk_color_switch.dart';

class DynamicTile extends StatefulWidget {
  final String endpoint;
  final Map<String, dynamic> item;
  final Map<String, dynamic> fieldKeys; // same as for details
  final Map<String, String>
      tileMapping; // e.g. { "title": "name", "subtitle": "role", "trailing": "status" }
  final VoidCallback? onTap;
  final VoidCallback? onLongPressed;
  final Function(bool)? onResult;
  final DynamicModuleController controller;

  DynamicTile(
      {super.key,
      required this.endpoint,
      required this.item,
      required this.fieldKeys,
      required this.tileMapping,
      this.onTap,
      this.onLongPressed,
      this.onResult,
      required this.controller});

  @override
  State<DynamicTile> createState() => _DynamicTileState();
}

class _DynamicTileState extends State<DynamicTile> {
  @override
  Widget build(BuildContext context) {
    final formatter = DataFormatter();

    return Card(
      color: Colors.white, // keep card background transparent
      elevation: 4, // optional shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.endpoint == "format"
          ? buildFormatTile(formatter, context)
          : widget.endpoint == 'uauc'
              ? buildObservationTile(formatter, context)
              : ListTile(
                  minLeadingWidth: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          formatter.formatCellValue(
                              widget.item[widget.tileMapping['title']],
                              widget.tileMapping['title'] ?? ''),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      // if (widget.item["editAllowed"])
                        IconButton(
                          onPressed: () async {
                            var result = await Get.toNamed(
                              Routes.formPage,
                              arguments: [widget.endpoint, widget.item, true],
                            );

                            if (result != null && widget.onResult != null) {
                              widget.onResult!(result);
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.tileMapping['subtitle'] != null)
                        Expanded(
                          child: Text(
                            formatter.formatCellValue(
                                widget.item[widget.tileMapping['subtitle']],
                                widget.tileMapping['subtitle']!),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (widget.tileMapping['trailing'] != null)
                        Row(
                          children: [
                            Text(
                              formatter.formatCellValue(
                                widget.item[widget.tileMapping['trailing']],
                                widget.tileMapping['trailing']!,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            sb20,
                            widget.item["status"] != null
                                ? PopupMenuButton<String>(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 6,
                                    color: Colors.white,
                                    initialValue: widget.item["status"],
                                    tooltip: "Change Status",
                                    onSelected: (value) async {
                                      bool confirmed =
                                          await showConfirmationDialog(
                                              context: context,
                                              title: "Confirm Change",
                                              content:
                                                  "Do you want to change Status");
                                      if (!confirmed) return; // user cancelled
                                      await widget.controller.updateStatus(
                                          widget.item["_id"] ?? "",
                                          {"status": value});

                                      setState(() {
                                        widget.item["status"] = value;
                                      });
                                    },
                                    itemBuilder: (context) => (widget
                                            .controller.statusList)
                                        .cast<String>()
                                        .map<PopupMenuEntry<String>>(
                                            (status) => PopupMenuItem<String>(
                                                  value: status,
                                                  child: Text(status),
                                                ))
                                        .toList(),
                                    child: Container(
                                      width: 80,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.item["status"] ?? "Select",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                    ],
                  ),
                  onTap: () {
                    showTileDetails(context, widget.item, widget.endpoint,
                        widget.controller);
                  },
                  onLongPress: widget.onLongPressed,
                ),
    );
  }

  Widget buildObservationTile(DataFormatter formatter, BuildContext context) {
    bool isOpen = widget.item['status'] == "Open" ? true : false;
    return InkWell(
      onLongPress: widget.onLongPressed,
      child: ExpansionTile(
          showTrailingIcon: false,
          title: InkWell(
            onTap: () {
              showTileDetails(
                  context, widget.item, widget.endpoint, widget.controller);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 6,
                  height: 30,
                  decoration: BoxDecoration(
                    color: getRiskColor(
                        widget.item['riskValue']?['severity'] ?? ""),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                sb8,
                Expanded(
                  child: Text(
                    formatter.formatCellValue(
                        widget.item[widget.tileMapping['title']],
                        widget.tileMapping['title'] ?? ''),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (widget.item["editAllowed"])
                  IconButton(
                    onPressed: () async {
                      var result = await Get.toNamed(
                        Routes.formPage,
                        arguments: [widget.endpoint, widget.item, true],
                      );

                      if (result != null && widget.onResult != null) {
                        widget.onResult!(result);
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
              ],
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.black54,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Assigned To: ",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black, // or your desired color
                            ),
                          ),
                          TextSpan(
                            text: formatter.formatCellValue(
                                widget.item['assignedTo'], "assignedTo"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // same color as above
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    sb6,
                    isOpen
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Close by: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color:
                                        Colors.black, // or your desired color
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${calculateActionCompletionTime(widget.item['riskValue'], DateTime.tryParse(widget.item['date']))}(${widget.item['riskValue']?['severity'] ?? "Value not available"})",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getRiskColor(widget.item['riskValue']
                                            ?['severity'] ??
                                        ""), // same color as above
                                  ),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        : RichText(
                            text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Observation Closed",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // or your desired color
                                ),
                              ),
                              // TextSpan(
                              //   text: IndianDateFormatters.formatWithTime(
                              //       DateTime.parse(item["closedOn"] ??
                              //           DateTime.now().toString)),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.black, // same color as above
                              //   ),
                              // ),
                            ],
                          )),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOpen ? Colors.yellow.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOpen
                        ? Colors.deepOrange.shade400
                        : Colors.blue.shade100,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "${widget.item['status']}",
                  style: TextStyle(
                    color: isOpen
                        ? Colors.deepOrange.shade700
                        : Colors.grey.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                onTap: () {
                  showTileDetails(
                      context, widget.item, widget.endpoint, widget.controller);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Created on ${formatter.formatCellValue(
                        widget.item[widget.tileMapping['trailing']],
                        widget.tileMapping['trailing']!,
                      )} at ",
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.tileMapping['subtitle'] != null)
                      Expanded(
                        child: Text(
                          formatter.formatCellValue(
                              widget.item[widget.tileMapping['subtitle']],
                              widget.tileMapping['subtitle']!),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    sb20,
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  buildFormatTile(DataFormatter formatter, BuildContext context) {
    return ListTile(
      minLeadingWidth: 0,
      trailing: IconButton(
        onPressed: () {
          Get.dialog(CustomAlertDialog(
              title: "Dounload?",
              description: "Download this file",
              buttons: [
                CustomDialogButton(
                    label: "Yes",
                    onPressed: () {
                      downloadFile(widget.item["FormatFile"][0]);
                    }),
                CustomDialogButton(
                    label: "Cancel",
                    onPressed: () {
                      Get.back();
                    })
              ]));
        },
        icon: Icon(Icons.sim_card_download_rounded),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              formatter.formatCellValue(
                  widget.item[widget.tileMapping['title']],
                  widget.tileMapping['title'] ?? ''),
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (widget.item["editAllowed"])
            IconButton(
              onPressed: () async {
                var result = await Get.toNamed(
                  Routes.formPage,
                  arguments: [widget.endpoint, widget.item, true],
                );

                if (result != null && widget.onResult != null) {
                  widget.onResult!(result);
                }
              },
              icon: const Icon(Icons.edit),
            ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.tileMapping['subtitle'] != null)
            Expanded(
              child: Text(
                formatter.formatCellValue(
                    widget.item[widget.tileMapping['subtitle']],
                    widget.tileMapping['subtitle']!),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (widget.tileMapping['trailing'] != null)
            Text(
              formatter.formatCellValue(
                widget.item[widget.tileMapping['trailing']],
                widget.tileMapping['trailing']!,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      onTap: () {
        Get.to(BrowserBottomSheetLauncher(url: widget.item["FormatFile"][0]));
      },
      onLongPress: widget.onLongPressed,
    );
  }
}

void showTileDetails(BuildContext context, Map<String, dynamic>? data,
    String endpoint, DynamicModuleController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      controller.isStatusActive.value =
          data?["status"] == "Open" ? true : false;
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Column(
            children: [
              // ✅ Custom AppBar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.appMainDark, // your theme color
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${translate(endpoint)} Details", // title
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ((data?["createdby"]?["_id"] as String?) ==
                                Strings.userId) &&
                            endpoint == "uauc"
                        ? Obx(() {
                            var isOpen = controller.isStatusActive.value;
                            return Row(
                              children: [
                                Text("Status:",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white,
                                    )),
                                Switch(
                                    activeColor: Colors.white,
                                    thumbColor: MaterialStateProperty
                                        .resolveWith<Color?>(
                                      (states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Colors.green; // thumb when ON
                                        }
                                        return Colors.white; // thumb when OFF
                                      },
                                    ),
                                    value: isOpen,
                                    onChanged: (val) {
                                      handleStatusToggle(
                                          context, controller, data, val);
                                    }),
                                Text(
                                  isOpen ? "Open" : "Closed",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          })
                        : endpoint == "uauc"
                            ? Text(
                                "Status: ${data?["status"] ?? ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              )
                            : sb1,
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text("Download as"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.picture_as_pdf,
                                        color: Colors.red),
                                    title: const Text("PDF"),
                                    onTap: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                      // TODO: Your download PDF logic
                                      print("Download PDF");
                                      saveDynamicDataPdf(data ?? {}, keysForMap,
                                          translate(endpoint));
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.image,
                                        color: Colors.blue),
                                    title: const Text("Image"),
                                    onTap: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                      // TODO: Your download Image logic
                                      print("Download Image");
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.ios_share_outlined,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // ✅ Scrollable body
              Expanded(
                child: DynamicDataPage(
                  data: data ?? {},
                  fieldKeys: keysForMap,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void handleStatusToggle(BuildContext context,
    DynamicModuleController controller, dynamic data, bool newValue) async {
  final isAnyFieldNullOrEmpty = data["actionTakenBy"] == null ||
      data["correctivePreventiveAction"] == null ||
      data["correctivePreventiveAction"].toString().trim().isEmpty ||
      data["actionTakenPhoto"] == null;

  if (isAnyFieldNullOrEmpty && data.status == "Open") {
    // Show warning: required fields are missing
    await Get.dialog(
      AlertDialog(
        title: const Text("Cannot Change Status"),
        content: const Text(
            "Action Taken By, Corrective Actions, and Action Taken Photo is Missing."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
    return;
  }

  // Ask for confirmation if everything is filled
  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      title: Text("Confirm Status Change"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "Are you sure you want to mark this as '${newValue ? "Open" : "Closed"}'?"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Get.back(result: true),
          child: const Text("Confirm"),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    controller.isStatusActive.value = newValue;
    await controller.updateStatus(
        data["_id"] ?? "", {"status": newValue ? "Open" : "Closed"});

    // Show success snackbar
    final now = DateTime.now();
    final formattedTime =
        "${now.day}-${now.month}-${now.year} at ${DateFormat('hh:mm a').format(now)}";

    Get.snackbar(
      "Status Changed",
      "Marked as ${newValue ? "Open" : "Closed"} on $formattedTime",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "Completed":
      return Colors.green.shade300;
    case "In Progress":
      return Colors.blue.shade300;
    case "On Hold":
      return Colors.orange.shade300;
    case "Closed":
      return Colors.grey.shade300;
    case "Pending":
      return Colors.yellow.shade300;
    default:
      return Colors.grey.shade200;
  }
}
