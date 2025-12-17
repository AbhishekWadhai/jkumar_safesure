import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sure_safe/services/image_service.dart';
import 'package:sure_safe/services/text_formatters.dart';

class ImageDetectController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Rx<File?> imageFile = Rx<File?>(null);
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> result = <String, dynamic>{}.obs;

  /// Pick image from camera
  Future<void> captureImage() async {
    if (isLoading.value) return; // 🔒 prevent second call

    var image = await Get.to(() => CameraPreviewScreen());

    if (image != null) {
      
      imageFile.value = File(image.path);
      await sendToApi(); // await is important
    }
  }

  /// Send image to backend
  Future<void> sendToApi() async {
    if (imageFile.value == null) return;

    isLoading.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://jkumarapi.axiomos.in/labour/recognize"),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.value!.path,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        result.value = jsonDecode(responseBody);
        printLargeJson(jsonDecode(responseBody));
      } else {
        Get.snackbar("Error", "Detection failed");
      }
    } catch (e) {
      print("API error: $e");
    } finally {
      isLoading.value = false;
      imageFile.value = null; // 🔥 VERY IMPORTANT
    }
  }
}
