import 'package:mercanlarlinux/Model/AracModel.dart';
import 'package:mercanlarlinux/View/Arac_Sayfa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';  // For decoding JSON data
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../Model/DatabaseHelper.dart';


class AracEkle extends StatefulWidget {
  @override
  _AracEkleState createState() => _AracEkleState();
}

class _AracEkleState extends State<AracEkle> {
  final TextEditingController _plakaController = TextEditingController();
  String? _errorMessage; // To store the error message

  Future<void> buttonAction(BuildContext context) async {
    // Check if the input is empty
    if (_plakaController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen plaka giriniz'; // Set error message
      });
      return; // Exit the function if input is empty
    }

    // If input is valid, clear the error message and proceed
    setState(() {
      DatabaseHelper().insertItem(_plakaController.text);
      _errorMessage = null;
    });

    // Proceed with the database insertion

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Araç Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the start of the column
          children: [
            TextField(
              controller: _plakaController,
              decoration: InputDecoration(
                labelText: 'Plaka', // Optional label
                errorText: _errorMessage, // This will show the error below the TextField
              ),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () => buttonAction(context),
              child: Text("Araç Ekle"),
            ),
          ],
        ),
      ),
    );
  }





/*final String apiUrl = "http://10.0.2.2:5273/Arac_";
  // Method to fetch posts
  void fetchPosts() async {
    final response = await http.get(Uri.parse(apiUrl));
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
  }*/
}