import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Barkod_Sayfa.dart';
import 'package:mercanlarlinux/View/Kargo_Bilgi.dart';
import 'package:mercanlarlinux/View/Kargo_Ekle.dart';
import '../Model/DatabaseHelper.dart';

class KargoSayfa extends StatefulWidget {

  final String plaka;
  KargoSayfa({required this.plaka});

  @override
  _KargoSayfaState createState() => _KargoSayfaState();
}

class _KargoSayfaState extends State<KargoSayfa> {
  int? _selectedIndex;
  late Future<List<Map<String,dynamic>>> kargoItems; // Future for fetching kargo items

  @override
  void initState() {
    super.initState();
    kargoItems = DatabaseHelper().fetchKargo(widget.plaka); // Initialize the future
  }

  void refreshItems() {
    setState(() {
      kargoItems = DatabaseHelper().fetchKargo(widget.plaka); // Refresh kargo items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kargo Sayfası'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(await DatabaseHelper().fetchKargo(widget.plaka));
          await DatabaseHelper().insertKargo("sdsaddsa",widget.plaka);
          Navigator.push(context, MaterialPageRoute(builder: (context) => KargoEkle()));
          print(widget.plaka);
          setState(() {
            kargoItems = DatabaseHelper().fetchKargo(widget.plaka);
          });
        },
        child: Icon(Icons.add), // Plus icon
        tooltip: 'Add',
      ),
      body: FutureBuilder<List<Map<String,dynamic>>>(
        future: kargoItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 100,
                  child: Kargo(snapshot.data![index]['name'], context,index),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget Kargo(String data, BuildContext context,int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            color: _selectedIndex == index
                ? Colors.blueAccent // Selected item background color
                : Colors.white, // Default background color
            border: Border.all(
              color: _selectedIndex == index ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "Tip",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "EvrakNo",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "Tarih",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "CariNo",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "Unvan",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "Resim",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "İmza",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "Teslim Tarihi",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "Teslim Alan",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      "İşlem",
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      data,
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white // Selected item text color
                            : Colors.black, // Default text color
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          )
        ),
      ),
    );
  }
}
