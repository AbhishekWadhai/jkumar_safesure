import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
//import 'package:image/image.dart' as img_pkg;
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart'; // For handling file paths
import 'package:path_provider/path_provider.dart';
import 'package:sure_safe/helpers/app_keys.dart'; // To access temporary directories

class CameraService with ChangeNotifier {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  int _currentCameraIndex = 0;
  bool _isInitialized = false;

  // Initialize the camera
  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _currentCameraIndex = 0;

      await _initController();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _initController() async {
    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    _isInitialized = false;
    notifyListeners();

    await _controller.dispose();

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;

    await _initController();
  }

  // Function to capture an image
  Future<File?> captureImage() async {
    if (!_isInitialized) {
      print('Camera is not initialized.');
      return null;
    }

    try {
      // Capture image
      final XFile picture = await _controller.takePicture();
      return File(picture.path);
    } catch (e) {
      print('Error capturing image: $e');
      return null;
    }
  }

  // Function to upload image to API and retrieve the URL
  Future<String?> uploadImage(File image, String endpoint, bool isSignature,
      {String? customFileName}) async {
    File? imageFile = isSignature ? image : await compressImage(image);
    if (imageFile == null) {
      print("Image compression failed.");
      return null;
    }

    try {
      // API URL
      final url = Uri.parse('https://jkumar.vercel.app/$endpoint');

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Get the file extension (e.g., .jpg, .png)
      String fileExtension = extension(imageFile.path);

      // Use the custom file name if provided, else use the original file name
      String fileName = customFileName != null
          ? '$customFileName$fileExtension'
          : basename(imageFile.path);

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Key for the image file in the form-data
          imageFile.path,
          filename: fileName, // Set the custom or original file name
        ),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 201) {
        // Get the response body
        var responseBody = await http.Response.fromStream(response);

        // Parse the response body and extract the URL
        var result = jsonDecode(responseBody.body);

        if (result != null && result["fileUrl"] != null) {
          return result["fileUrl"]; // Return the file URL
        } else {
          print('Invalid response format');
          return null;
        }
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<File?> compressImage(File imageFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = imageFile.absolute.path;

      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: 70,
        minWidth: 1080,
        minHeight: 1080,
      );

      if (compressedImage == null) {
        print('Compression failed.');
        return null;
      }

      return File(compressedImage.path);
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // Dispose the camera controller
  Future<void> dispose() async {
    await _controller.dispose();
  }

  // Check if the camera is initialized
  bool get isInitialized => _isInitialized;

  // Provide the controller to be used in UI for camera preview
  CameraController get controller => _controller;
}

// class CameraPreviewScreen extends StatefulWidget {
//   @override
//   _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
// }

// class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
//   late CameraService _cameraService;
//   bool _isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _cameraService = CameraService();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       await _cameraService.initializeCamera();
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing camera: $e');
//     }
//   }

//   Future<void> _captureImage() async {
//     try {
//       final image = await _cameraService.captureImage();
//       if (image != null) {
//         // Return the captured image to the calling function
//         Get.back(result: image);
//       }
//     } catch (e) {
//       print('Error capturing image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isCameraInitialized
//           ? Stack(
//               children: [
//                 SafeArea(
//                   child: CameraPreview(_cameraService.controller),
//                 ),

//                 // 🔁 Switch Camera Button (Top Right)
//                 // Positioned(
//                 //   top: 20,
//                 //   right: 20,
//                 //   child:
//                 // ),

//                 // 📸 Capture Button
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         FloatingActionButton(
//                           onPressed: _captureImage,
//                           backgroundColor: Colors.red,
//                           child: const Icon(Icons.camera_alt),
//                         ),
//                         FloatingActionButton(
//                           heroTag: 'switchCam',
//                           backgroundColor: Colors.black54,
//                           onPressed: () async {
//                             await _cameraService.switchCamera();
//                             setState(() {});
//                           },
//                           child: const Icon(Icons.cameraswitch),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraService.dispose();
//     super.dispose();
//   }
// }

// Future<File?> renderWidgetToFileUsingNavigatorKey(Widget widget,
//     {double pixelRatio = 3.0}) async {
//   final navState = navigatorKey.currentState;
//   final overlay = navState?.overlay;
//   if (overlay == null) {
//     // Not ready yet — either app not mounted or navigatorKey not attached.
//     print('No overlay available (navigatorKey.currentState?.overlay == null)');
//     return null;
//   }

//   final key = GlobalKey();
//   final entry = OverlayEntry(
//     builder: (context) {
//       return Offstage(
//         offstage: false, // must not be true; we need it laid out & painted
//         child: Material(
//           type: MaterialType.transparency,
//           child: Center(
//             child: RepaintBoundary(
//               key: key,
//               child: widget,
//             ),
//           ),
//         ),
//       );
//     },
//   );

//   overlay.insert(entry);

//   // Wait for at least one frame so the widget is built & painted.
//   // A small delay + endOfFrame tends to be robust.
//   await Future.delayed(const Duration(milliseconds: 50));
//   await WidgetsBinding.instance.endOfFrame;
//   await Future.delayed(const Duration(milliseconds: 50));

//   try {
//     final boundary =
//         key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//     if (boundary == null) {
//       print('RenderRepaintBoundary not found');
//       return null;
//     }

//     final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
//     final ByteData? byteData =
//         await image.toByteData(format: ui.ImageByteFormat.png);
//     if (byteData == null) return null;
//     final Uint8List pngBytes = byteData.buffer.asUint8List();

//     final dir = await getTemporaryDirectory();
//     final file = File(
//         '${dir.path}/composed_${DateTime.now().millisecondsSinceEpoch}.png');
//     await file.writeAsBytes(pngBytes);
//     return file;
//   } catch (e, st) {
//     print('capture error: $e\n$st');
//     return null;
//   } finally {
//     entry.remove();
//   }
// }

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;

  bool _initialized = false;
  Position? _position;
  String _address = "Fetching location...";

  final GlobalKey _repaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initEverything();
  }

  Future<void> _initEverything() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();

    _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await _getAddressFromLatLng();

    setState(() {
      _initialized = true;
    });
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        _position!.latitude,
        _position!.longitude,
      );

      final place = placemarks.first;
      _address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
    } catch (e) {
      _address = "Address unavailable";
    }
  }

  Future<void> _captureStampedImage() async {
    try {
      final boundary = _repaintKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final Uint8List bytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/stamped_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await file.writeAsBytes(bytes);

      Get.back(result: file);
    } catch (e) {
      debugPrint("Capture failed: $e");
    }
  }

  Widget _overlayWidget() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd MMM, yyyy').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);

    return Positioned(
      bottom: 16,
      right: 16,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 260, // 🔥 prevents layout expansion
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.65),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 🔥 important
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$formattedDate, $formattedTime",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$_address (${_position!.latitude.toStringAsFixed(5)}, "
                  "${_position!.longitude.toStringAsFixed(5)})",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: 3, // 🔥 prevents vertical stretch
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _position == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    Widget cameraPreview() {
      final size = MediaQuery.of(context).size;
      final cameraRatio = _controller.value.aspectRatio;

      // Android camera sensor is landscape
      final isPortrait = size.height > size.width;
      final previewRatio = isPortrait ? (1 / cameraRatio) : cameraRatio;

      return Center(
        child: OverflowBox(
          maxWidth: size.width,
          maxHeight: size.height,
          child: FittedBox(
            fit: BoxFit.cover, // 🔥 fill screen, crop excess
            child: SizedBox(
              width: size.width,
              height: size.width / previewRatio,
              child: Stack(
                children: [
                  CameraPreview(_controller),
                  _overlayWidget(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RepaintBoundary(
            key: _repaintKey,
            child: cameraPreview(),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: _captureStampedImage,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}