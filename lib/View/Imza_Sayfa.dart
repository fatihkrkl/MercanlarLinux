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

  Uint8List pngBytes=Uint8List(80);
  File? file;

  @override
  void initState() {
    super.initState();
    filePath();
  }

  Future<void> filePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/imgfile.jpeg';
    file= File(filePath);
  }

 void _getImageData() async {
   List<int> imza = await (await _drawingController.getImageData())?.buffer.asInt8List() as List<int>;
    await file?.writeAsBytes(Uint8List.fromList(imza));
   print(file?.readAsBytesSync());
    setState(() {});
  }


  Future<void> reset() async {
    await file?.writeAsBytes(Uint8List.fromList(Uint8List(80)));
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
                future: file?.exists().then((exists) => exists),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error checking image existence."));
                  } else if (snapshot.data == false || file == null) {
                    return Center(child: Container());
                  } else {
                    imageCache.clear();
                    if(!file!.readAsBytesSync().every((byte) => byte == 0)){
                      return Expanded(child: Image.file(file!, key: UniqueKey()));
                    }else{
                      return Expanded(child: Container());
                    }
                  }
                },
              ),
            ],
          ),
        ));
  }
}
