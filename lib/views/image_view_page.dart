import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewPage extends StatelessWidget {
  final String imageUrl;

  const ImageViewPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Image'),
      ),
      body: PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final String imageUrl =
      "https://example.com/your-image-url.jpg"; // replace with your image URL

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Open the image in full-screen mode
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewPage(imageUrl: imageUrl),
          ),
        );
      },
      child: SizedBox(
        height: 200,
        width: 200,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.network(
            imageUrl,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
