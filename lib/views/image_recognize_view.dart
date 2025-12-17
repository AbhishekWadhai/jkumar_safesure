import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sure_safe/controllers/image_recognize_controller.dart';
import 'package:sure_safe/services/translation.dart';
import 'package:sure_safe/widgets/dynamic_data_view.dart';

class ImageDetectPage extends StatelessWidget {
  final controller = Get.put(ImageDetectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Detection")),
      body: Obx(() {
        return Column(
          children: [
            const SizedBox(height: 20),

            /// Image Preview
            controller.imageFile.value != null
                ? Image.file(
                    controller.imageFile.value!,
                    height: 250,
                  )
                : const Text("No image selected"),

            const SizedBox(height: 20),

            /// Button
            Obx(() => FloatingActionButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.captureImage,
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Icon(Icons.camera_alt),
                )),

            const SizedBox(height: 20),

            /// Loader
            if (controller.isLoading.value) const CircularProgressIndicator(),

            const SizedBox(height: 20),

            /// Result
            if (controller.result.isNotEmpty)
              Expanded(
                  child: DynamicDataPage(
                      data: controller.result["labour"],
                      fieldKeys: keysForMap)),
          ],
        );
      }),
    );
  }
}
