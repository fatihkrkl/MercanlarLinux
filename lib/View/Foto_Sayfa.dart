import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Resim_Sayfa.dart';

class FotoSayfa extends StatelessWidget{
  bool imza;
  String path;
  FotoSayfa({required this.path,required this.imza});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resim"),
      ),
      body: Column(
        children: [
          Expanded(
              child: Image.file(File(path)),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResimSayfa(imza: imza))), child: Text("Değiştir"))
            ],
          )
        ],
      ),
    );
  }

}