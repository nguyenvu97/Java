import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class editedImage extends StatefulWidget {
  const editedImage({super.key});

  @override
  State<editedImage> createState() => _editedImageState();
}

class _editedImageState extends State<editedImage> {
  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    loadAsset("gomi.jpg");
  }

  void loadAsset(String name) async {
    var data = await rootBundle.load('asset/$name');
    setState(() => imageData = data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageEditor Example"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageData != null) Image.memory(imageData!),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Single image editor"),
            onPressed: () async {
              var editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: imageData,
                  ),
                ),
              );

              // replace with edited image
              if (editedImage != null) {
                imageData = editedImage;
                setState(() {});
              }
            },
          ),
          ElevatedButton(
            child: const Text("Multiple image editor"),
            onPressed: () async {
              var editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    images: [
                      imageData,
                      imageData,
                    ],
                  ),
                ),
              );

              // replace with edited image
              if (editedImage != null) {
                imageData = editedImage;
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
