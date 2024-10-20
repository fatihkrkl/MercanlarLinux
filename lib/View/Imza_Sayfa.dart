import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImzaSayfa extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hehe"),
      ),
      body: Column(
        children:[
          Row(
            children: [
              Text("Teslim Alan:"),
              SizedBox(width: 12,),
              Expanded(
                child: TextField(

                ),
              )
            ],
          ),
          SizedBox(height: 50,),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue, // Border color
                    width: 2, // Border width
                  ),
                  borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                ),
              ),
            ),
          ),
          Expanded(flex: 1,child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Kaydet")))
        ]
      ),
    );
  }

}