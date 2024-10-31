import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:path_provider/path_provider.dart';

class ImzaSayfa extends StatefulWidget {
  @override
  _ImzaSayfaState createState() => _ImzaSayfaState();
}

class _ImzaSayfaState extends State<ImzaSayfa> {
  final DrawingController _drawingController = DrawingController();
  List<int> imza = Uint8List(80);
  Uint8List pngBytes=Uint8List(80);
  late File file;
  late MemoryImage _img;

 void _getImageData() async {
    imza = await (await _drawingController.getImageData())?.buffer.asInt8List() as List<int>;
    img.Image? image = img.decodeImage(Uint8List.fromList(imza));
    if (image == null) {
      print("Error decoding the image.");
      return;
    }
    _img=MemoryImage(Uint8List.fromList(imza));
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/imgfile.jpeg';

    await File(filePath).writeAsBytes(Uint8List.fromList(imza));
    file= File(filePath);
    setState(() {});
  }


  void reset() {
    imza = Uint8List(80);
    _drawingController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Drawing App'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  // Set border color and width
                  borderRadius:
                      BorderRadius.circular(8), // Optional: rounded corners
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  // Match the border radius if needed
                  child: DrawingBoard(
                    controller: _drawingController,
                    background:
                        Container(width: 400, height: 400, color: Colors.white),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: _getImageData, child: Text("Kaydet"))),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: reset, child: Text("Sıfırla"))),
                ],
              ),
              FutureBuilder<bool>(
                future: file.exists().then((exists) => exists),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator()); // Loading indicator
                  } else if (snapshot.hasError ) {
                    return Center(child: Text("Image does not exist.")); // Handle error case
                  } else if(!snapshot.data!){
                    return Center(child: Container(),);
                  }else {
                    // içi boş olunca böyle gözüküyor onu kontrol etmek lazım
                    return Expanded(child: Image.memory(Uint8List.fromList(imza))); // Show the image
                  }
                },
              )
            ],
          ),
        ));
  }
}
