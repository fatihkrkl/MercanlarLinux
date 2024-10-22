import 'package:mercanlarlinux/View/Arac_Sayfa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';  // For decoding JSON data
import 'package:http/http.dart' as http;


class AracEkle extends StatelessWidget{

  final String apiUrl = "https://10.234.11.113:7043/Arac_";

  // Method to fetch posts
  void fetchPosts() async {
    final response = await http.get(Uri.parse(apiUrl));
    print("dsadsa");
    print(await jsonDecode(response.body));
  }
  
  // Method to create a new post
  Future<void> createPost(dynamic body) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': "sda",
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 201) {
      print('Post created successfully  :$response');
    } else {
      throw Exception('Failed to create post');
    }
  }
  void buttonAction(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AracSayfa()),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hehe"),
      ),
      body: Row(
          children:[
            ElevatedButton(onPressed: () => fetchPosts(), child: Text("Araç Ekle")),
            Text("dsadsa"),
          ]
      ),
    );
  }

}