import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';

class ImzaSayfa extends StatefulWidget {
  @override
  _ImzaSayfaState createState() => _ImzaSayfaState();
}

class _ImzaSayfaState extends State<ImzaSayfa> {
  final DrawingController _drawingController = DrawingController();
  List<int> imza=Uint8List(80);


  Future<List<int>> _getImageData() async {
    print("object");
    imza = await (await _drawingController.getImageData())?.buffer.asInt8List() as List<int>;
    setState(() {

    });
    return (await _drawingController.getImageData())?.buffer.asInt8List() as List<int>;
  }

  bool isImzaEmpty() {
    return imza.isEmpty || imza.every((element) => element == 0);
  }

  @override
  Widget build(BuildContext context) {
    print(imza);
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            child: DrawingBoard(
              controller: _drawingController,
              background: Container(width: 400, height: 400, color: Colors.white),
            ),
          ),
          ElevatedButton(onPressed: _getImageData, child: Text("Kaydet")),
          isImzaEmpty()
              ? CircularProgressIndicator() // Show loading indicator if imza is empty
              : Image.memory(
            Uint8List.fromList(imza), // Display the image if imza has data
            fit: BoxFit.cover,
          ),
        ],
      )
    );
  }
}

