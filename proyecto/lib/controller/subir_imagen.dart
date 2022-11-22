import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoUpload extends StatefulWidget {
  const PhotoUpload({Key? key}) : super(key: key);

  @override
  State<PhotoUpload> createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  File? sampleImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subida de imagen"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null
            ? const Text("Selecciona una imagen")
            : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Añade una imagen",
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  enableUpload() {}

  Future getImage() async {
    var tempImage =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = File(tempImage!.path);
    });
  }
}
