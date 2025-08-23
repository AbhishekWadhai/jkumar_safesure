import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sure_safe/controllers/dynamic_form_contoller.dart';
import 'package:sure_safe/model/form_data_model.dart';
import 'package:sure_safe/services/location_service.dart';


import 'form_extras.dart';

Widget buildGeolocation(
  PageField field,
  bool isEditable,
  DynamicFormController controller,
) {
  return Obx(() {
    String? currentLocation = controller.formData[field.headers];
    double? latitude, longitude;

    RegExp regex = RegExp(r'\(([^,]+),\s*([^)]+)\)');
    Match? match = regex.firstMatch(currentLocation ?? "");

    if (match != null) {
      latitude = double.tryParse(match.group(1)!);
      longitude = double.tryParse(match.group(2)!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (!isEditable) return null;
            return controller.validateTextField(value);
          },
          controller: TextEditingController(text: currentLocation),
          readOnly: true,
          decoration: kTextFieldDecoration("Location"),
          onTap: isEditable
              ? () async {
                  if (controller.isOnline.value) {
                    // Online: fetch and show map
                    await controller.fetchGeolocation(field.headers);
                    if (latitude != null && longitude != null) {
                      showGeolocationDialog(
                        latitude: latitude,
                        longitude: longitude,
                        onLocationSelected: (LatLng newPos) {
                          final value =
                              "(${newPos.latitude}, ${newPos.longitude})";
                          controller.formData[field.headers] = value;
                         // controller.saveLocationOffline(value); // save for offline
                        },
                      );
                    }
                  } else {
                    // Offline: show saved locations
                    final List<String> savedLocations =
                        await controller.getSavedLocations();
                    if (savedLocations.isEmpty) {
                      Get.snackbar("No Locations",
                          "No saved locations available offline.");
                      return;
                    }

                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: savedLocations.map((loc) {
                            return ListTile(
                              title: Text(loc),
                              onTap: () {
                                controller.formData[field.headers] = loc;
                                Get.back(); // close bottom sheet
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                }
              : null,
        ),
        if (!isEditable)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Location is read-only.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        const SizedBox(height: 10),
      ],
    );
  });
}
