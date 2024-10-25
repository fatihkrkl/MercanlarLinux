import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Resim_Sayfa.dart';
import 'package:mercanlarlinux/View/Foto_Sayfa.dart';

class KargoBilgi extends StatefulWidget {
  final String barkod;
  static String imzapath = "";
  static String resimpath = "";

  KargoBilgi({required this.barkod});

  @override
  _KargoBilgiState createState() => _KargoBilgiState();
}

class _KargoBilgiState extends State<KargoBilgi> {
  @override
  Widget build(BuildContext context) {
    List<String> elementList = [
      "value1",
      'value2',
      'value3',
      'value4',
      'value5',
      'value6',
      'value7',
      'value8'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Kargo Bilgileri"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                button("Kaynak"),
                button("Resim"),
                button("Göster"),
                button("İmza"),
                button("Sil"),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(widget.barkod, style: TextStyle(color: Colors.red)),
          SizedBox(
            height: 12,
          ),
          Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 4, // Number of columns
                children: List.generate(8, (index) {
                  if (index < 4) {
                    // For the first 4 items
                    List<String> labels = ["Tip", "Evrak", "Tarih", "Cari No"];
                    return Center(
                      child: Text(
                        labels[index],
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    );
                  } else {
                    // For the next 4 items, use elementList
                    return Center(
                      child: Text(
                        elementList[index - 4],
                        // Subtract 4 to get the correct element
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    );
                  }
                }),
              )),
          SizedBox(
            height: 12,
          ),
          Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 4, // Number of columns
                children: List.generate(8, (index) {
                  if (index < 4) {
                    // For the first 4 items
                    List<String> labels = [
                      "Unvan",
                      "Teslim Tarihi",
                      "Teslim Alan",
                      "İşlem"
                    ];
                    return Center(
                      child: Text(
                        labels[index],
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    );
                  } else {
                    // For the next 4 items, use elementList
                    return Center(
                      child: Text(
                        elementList[index],
                        // Subtract 4 to get the correct element
                        style: TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    );
                  }
                }),
              )),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Resim"),
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                // Check if the image path is empty
                                if (KargoBilgi.resimpath.isEmpty) {
                                  // Navigate to FotoSayfa if the path is empty
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ResimSayfa( imza: false)),
                                  ).then((val) {
                                    setState(() {
                                      // Handle any state changes after returning from FotoSayfa
                                    });
                                  });
                                } else {
                                  // Navigate to FotoSayfa with the image path
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FotoSayfa(path: KargoBilgi.resimpath, imza: false)),
                                  ).then((val) {
                                    setState(() {
                                      // Handle any state changes after returning from FotoSayfa
                                    });
                                  });
                                }
                              },
                              child: Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue, // Border color
                                    width: 2, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                                ),
                                child: KargoBilgi.resimpath.isEmpty
                                    ? const Center(
                                  child: Text("Resim yok"), // Show when no image is available
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(KargoBilgi.resimpath)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("İmza"),
                        Expanded(
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                // Check if the image path is empty
                                if (KargoBilgi.imzapath.isEmpty) {
                                  // Navigate to FotoSayfa if the path is empty
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ResimSayfa( imza: true)),
                                  ).then((val) {
                                    setState(() {
                                      // Handle any state changes after returning from FotoSayfa
                                    });
                                  });
                                } else {
                                  // Navigate to FotoSayfa with the image path
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FotoSayfa(path: KargoBilgi.imzapath, imza: true)),
                                  ).then((val) {
                                    setState(() {
                                      // Handle any state changes after returning from FotoSayfa
                                    });
                                  });
                                }
                              },
                              child: Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue, // Border color
                                    width: 2, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                                ),
                                child: KargoBilgi.imzapath.isEmpty
                                    ? const Center(
                                  child: Text("İmza yok"), // Show when no image is available
                                )
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(KargoBilgi.imzapath)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ))
        ]),
      ),
    );
  }

  Widget button(String text) {
    return Expanded(
        child: TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ))),
            onPressed: () => (),
            child: Text(text)));
  }
}
