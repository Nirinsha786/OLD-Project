import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image2pdf_easyconvert/created_pdfs_page.dart';
import 'package:image2pdf_easyconvert/images_list.dart';
import 'package:image2pdf_easyconvert/selected_images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:external_path/external_path.dart';

class MainPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkTheme;

  const MainPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ImagesList imagesList = ImagesList();

  void _pickGalleryImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      imagesList.clearImagesList();
      imagesList.imagePaths.addAll(images);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedImages(
            imagesList: imagesList,
            screenName: "Selected Images",
            textStyle:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void _captureCameraImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagesList.clearImagesList();
      imagesList.imagePaths.add(image);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedImages(
            imagesList: imagesList,
            screenName: "Selected Image",
            textStyle:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  void _showCreatedPDFs() async {
    final pathToSave = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOCUMENTS,
    );
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatedPDFsPage(directoryPath: pathToSave),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image to PDF Converter",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(2, 2),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFEE0909),
        foregroundColor: Colors.white,
        actions: [
          Semantics(
            label: widget.isDarkTheme
                ? 'Switch to Light Theme'
                : 'Switch to Dark Theme',
            child: IconButton(
              icon:
                  Icon(widget.isDarkTheme ? Icons.nights_stay : Icons.wb_sunny),
              onPressed: widget.onToggleTheme,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(
              label: 'Pick Images from Gallery',
              onPressed: _pickGalleryImages,
              icon: Icons.photo_library,
              buttonText: "Gallery Images",
              fontSize: 22,
            ),
            const Gap(20),
            _buildButton(
              label: 'Capture Image with Camera',
              onPressed: _captureCameraImage,
              icon: Icons.camera_alt,
              buttonText: "Camera Image",
              fontSize: 22,
            ),
            const Gap(20),
            _buildButton(
              label: 'View Saved PDFs',
              onPressed: _showCreatedPDFs,
              icon: Icons.picture_as_pdf,
              buttonText: "View Saved PDF",
              fontSize: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required IconData icon,
    required String buttonText,
    required double fontSize,
  }) {
    return Semantics(
      label: label,
      child: MaterialButton(
        color: const Color(0xFFEE0909),
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const Gap(10),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: fontSize,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
