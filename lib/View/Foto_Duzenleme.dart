import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:mercanlarlinux/View/Kargo_Bilgi.dart';

class FotoDuzen extends StatelessWidget{
  XFile photo;
  FotoDuzen({required this.photo});

  void buttonAction(BuildContext context){
    KargoBilgi.resimpath=photo.path;
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<XFile> cropSquareImage(XFile imageFile) async {
    // Read the image file as bytes
    final Uint8List imageBytes = await imageFile.readAsBytes();

    // Decode the image
    img.Image? capturedImage = img.decodeImage(imageBytes);

    if (capturedImage == null) {
      throw Exception('Could not decode image.');
    }

    // Determine the square crop size
    int cropSize = capturedImage.width < capturedImage.height
        ? capturedImage.width
        : capturedImage.height;

    // Calculate the x and y coordinates for cropping from the center
    int x = (capturedImage.width - cropSize) ~/ 2;
    int y = (capturedImage.height - cropSize) ~/ 2;

    // Crop the image to a square
    img.Image croppedImage = img.copyCrop(capturedImage, x:x, y:y, width: cropSize, height: cropSize);

    // Encode the cropped image to JPEG or PNG
    final List<int> croppedBytes = img.encodeJpg(croppedImage);

    // Create a temporary directory to save the cropped image
    final Directory directory = await Directory.systemTemp.createTemp();
    final String path = '${directory.path}/cropped_image.jpg';

    // Write the cropped image to the file
    final File croppedFile = File(path);
    await croppedFile.writeAsBytes(croppedBytes);
    photo=XFile(croppedFile.path);
    // Create and return an XFile from the cropped file
    return photo;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fotoğraf"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: FutureBuilder(future: cropSquareImage(photo), builder: (context,snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                return Image.file(File(snapshot.data!.path));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),

          ElevatedButton(onPressed: () => buttonAction(context), child: Text("Kaydet"))
        ],
      )
    );
  }

}