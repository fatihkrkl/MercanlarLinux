import 'package:flutter/material.dart';
import 'Arac_Sayfa.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? loggedMail;

class GirisSayfa extends StatefulWidget {
  @override
  _GirisSayfaState createState() => _GirisSayfaState();
}

class _GirisSayfaState extends State<GirisSayfa> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DraggableScrollableController _scrollController = DraggableScrollableController();
  final url = Uri.parse("http://10.34.13.243:4444/api/v1/PdaUser");
  int? selectedDb;
  int? selectedDepo;

  void _getDb(BuildContext context, List<Map<String, dynamic>> list,String token) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // For full-height modal
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: list.length, // Replace with your list's length
                itemBuilder: (context, index) {
                  String txt = list[index]['databaseName'];
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(txt),
                    onTap: () async {
                      selectedDb=index;

                      print(token);
                      bool? db = await setTokenDatabase(token, list[index]['databaseId']);
                      if (db){
                        List<Map<String,dynamic>> list2= await getDepolist(token);
                         _depoListe(context,list2,token);
                        try{

                        }catch(ex){
                          print(ex);
                        }

                      }
                      Navigator.pop(context); // Dismiss bottom sheet
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> setTokenDatabase(String token, int databaseId) async {
    try{
      final dynamic jsonResponse= await postResponse('/setTokenDatabase',body: {'token':token,'databaseId':databaseId});
      final Map<String, dynamic> resp = jsonResponse as Map<String, dynamic>;
      if (resp.isNotEmpty) {
        final bool result = resp['isSucceded'] as bool? ?? false; // Default to false if null
        return result;
      }
      return false;
    }catch(ex){
      throw ex;
    }
  }

  Future<bool> setTokenDepoId(String token, int depoId) async {
    try{
      final dynamic jsonResponse= await postResponse('/setTokenDepoId',body: {'token':token,'databaseId':depoId});
      final Map<String, dynamic> resp= jsonResponse as Map<String, dynamic>;
      if (resp.isNotEmpty) {
        final bool result = resp['isSucceded'] as bool? ?? false; // Default to false if null
        return result;
      }
      return false;
    }catch(ex){
      throw ex;
    }
  }



  Future<List<Map<String, dynamic>>> getDepolist(String token) async {
    try{
      final dynamic jsonResponse= await getResponse('/getUserDepo',token: token);
      final List<Map<String, dynamic>> list = jsonResponse.cast<Map<String, dynamic>>();
      if(list.isNotEmpty) {
        return list;
      }
      throw Exception("Deponuz bulunmamakta");
    }catch(ex){
      throw ex;
    }

  }

  Future<List> getResponse(String path,{required String token}) async {
    final headers = {
      "Content-Type": "application/json",
      "accept": "text/plain",
      "Authorization": "Bearer $token"
    };
    final response = await http.get(Uri.parse('$url$path'), headers: headers);
    print("get$path");
    if (response.statusCode == 200) {
      print("get successful$path");
      print(response.body); // Handle the response data
      final dynamic jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception(response.body);
    }
  }
  Future<dynamic> postResponse(String path, {String token = '', Map<String, dynamic> body = const {}}) async {

    final headers = {
      "accept": "text/plain",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    Uri uri = Uri.parse('$url$path');
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body), // Ensure the body is JSON-encoded
    );
    print("post$path");
    if (response.statusCode == 200) {
      print("post successful$path");
      print(response.body); // Handle the response data
      final dynamic jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      throw Exception("Bağlantı Sorunu2");
    }
  }


  void _depoListe(BuildContext context, List<Map<String, dynamic>> list,String token) {
    print(list);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // For full-height modal
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: list.length, // Replace with your list's length
                itemBuilder: (context, index) {
                  String txt = list[index]['databaseName'];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("list[index]['aciklama']"),
                    onTap: () async {
                      selectedDepo=index;
                      bool depo= await setTokenDepoId(token, list[index]['depoId']);
                      if(depo){}
                      Navigator.pop(context); // Dismiss bottom sheet
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    try{
      if (email.isNotEmpty || password.isNotEmpty) {
        try{
          final dynamic jsonResponse= await postResponse('/login',body: {'userName':email,'password':password});
          final Map<String, dynamic> response = jsonResponse as Map<String, dynamic>;
          if(response['Error']=="false"){
            String token=response['MobileToken'];
            try{
              final dynamic jsonResponse= await getResponse('/getUserDatabase',token: token);
              final List<Map<String, dynamic>> list = jsonResponse.cast<Map<String, dynamic>>();
              _getDb(context, list,token);
            }catch(ex){
              throw ex;
            }
          }else{
            throw Exception('mail ya da şifre yanlış');
          }
        }catch(ex){
          throw ex;
        }
      }else{
        throw Exception('Kullanıcı bilgileriniz eksik');
      }
    }catch(ex){
      _showErrorDialog(context, ex.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Eposta',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Giriş'),
            ),
          ],
        ),
      ),
    );
  }
}
