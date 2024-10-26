import 'package:mercanlarlinux/Model/DatabaseHelper.dart';
import 'package:mercanlarlinux/View/Kargo_Sayfa.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/AracModel.dart';
import 'Arac_Ekle.dart';

class AracSayfa extends StatefulWidget {
  @override
  _AracSayfaState createState() => _AracSayfaState();
}

class _AracSayfaState extends State<AracSayfa> {
  Future<List<Map<String, dynamic>>> items=DatabaseHelper().fetchItems();



  void removeItem(String plaka) async {
    print(await DatabaseHelper().fetchItems());
    try {
      setState(() {
        DatabaseHelper().deleteItem(plaka);
        items=DatabaseHelper().fetchItems();
      });
    } catch (ex) {
      // You can handle the exception or show a dialog here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Hata"),
            content: Text(ex.toString()),
            actions: [
              TextButton(
                child: Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AracEkle()),
                    ).then((val) async {
                      setState(() {
                        items=DatabaseHelper().fetchItems();
                      });
                    });
                    print('Button 1 Pressed');
                  },
                  child: const Text('Yeni'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for Button 2
                    print('Button 2 Pressed');
                  },
                  child: Text('Listele'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for Button 3
                    print('Button 3 Pressed');
                  },
                  child: Text('Filtre'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(future: items, builder: (context,snapshot){
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child:
                      Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 100,
                        child: Card(
                          elevation: 4,
                          child: Center(
                            child: Arac(snapshot.data![index]['plaka'], context),
                          ),
                        ),
                      );
                    },
                  );
                }else {
                  return const Center(
                      child: Text('No data available'));
                }
              })
            ),
          ],
        ),
      ),
    );
  }

  Widget Arac(String plaka, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(plaka, style: TextStyle(fontSize: 18)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KargoSayfa(plaka: plaka,)),
                    );
                  },
                  child: Text("Görüntüle"),
                ),
                ElevatedButton(
                  onPressed: () => removeItem(plaka),
                  child: Text("Sil"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
