import 'package:mercanlarlinux/View/Arac_Sayfa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AracEkle extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hehe"),
      ),
      body: Row(
          children:[
            ElevatedButton(onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AracSayfa()),
            ), child: Text("Araç Ekle")),
            Text("dsadsa"),
          ]
      ),
    );
  }

}