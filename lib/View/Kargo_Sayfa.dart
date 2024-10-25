import 'package:flutter/material.dart';
import '../Model/DatabaseHelper.dart';
import 'Imza_Sayfa.dart';

class KargoSayfa extends StatefulWidget {
  final String plaka;

  KargoSayfa({required this.plaka});

  @override
  _KargoSayfaState createState() => _KargoSayfaState();
}

class _KargoSayfaState extends State<KargoSayfa> {
  late Future<List<Map<String, dynamic>>> kargoItems;
  int? selectedIndex; // Track selected item index
  int selectedBarcode = -1;

  @override
  void initState() {
    kargoItems = DatabaseHelper().fetchKargo(widget.plaka);
    super.initState();
  }

  void refreshItems() {
    setState(() {
      kargoItems = DatabaseHelper().fetchKargo(widget.plaka);
    });
  }

  void Deneme(BuildContext context) {
    print("dsadsa");
  }

  void Ekle(int barkod) async {
    await DatabaseHelper().insertKargo(
        barkod,
        widget.plaka,
        "deneme",
        "deneme",
        "deneme",
        "deneme",
        "deneme",
        "deneme",
        "deneme",
        "deneme",
        "deneme",
        "deneme");
    setState(() {
      refreshItems();
    });
  }

  void Sil(int barkod) async {
    selectedIndex != null ? await DatabaseHelper().deleteKargo(barkod): ();
    selectedIndex=null;
    selectedBarcode=-1;
    refreshItems();
  }

  void Imza(BuildContext context) {
    selectedIndex != null ? Navigator.push(context, MaterialPageRoute(builder: (context) => ImzaSayfa())): ();
  }

  @override
  Widget build(BuildContext context) {
    print(selectedBarcode);
    print(selectedIndex);
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kargo Sayfası'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Satir(
                    tip: "tip",
                    evrakno: "evrakno",
                    tarih: "tarih",
                    carino: "carino",
                    unvan: "unvan",
                    resim: "resim",
                    imza: "imza",
                    teslimtarihi: "teslimtarihi",
                    teslimalan: "teslimalan",
                    islem: "islem"),
                Container(
                  width: 1050,
                  height: screenHeight - 210,
                  child: FutureBuilder(
                    future: kargoItems,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> veri = snapshot.data![index];
                            bool isSelected = selectedIndex == index;
                            selectedBarcode = snapshot.data![index]['barkod'];


                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index; // Set selected index
                                });
                              },
                              child: Satir(
                                tip: veri["tip"],
                                evrakno: veri["evrakno"],
                                tarih: veri["tarih"],
                                carino: veri["carino"],
                                unvan: veri["unvan"],
                                resim: veri["resim"],
                                imza: veri["imza"],
                                teslimtarihi: veri["teslimtarih"],
                                teslimalan: veri["teslimalan"],
                                islem: veri["islem"],
                                isSelected: isSelected, // Pass selection status
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Column(
              children: [
                Expanded(
                  child: selectedIndex == null
                      ? Opacity(
                    opacity:
                    0.5, // Set opacity to make it transparent
                    child: Row(
                      children: [
                        buton("Kaynak", Colors.purple, Deneme, context),
                        buton("İmza", Colors.yellow, Imza, context),
                        SilButonu("Sil", Colors.red, Sil, selectedBarcode!),

                      ],
                    ),
                  )
                      : Row(
                    children: [
                      buton("Kaynak", Colors.purple, Deneme, context),
                      buton("İmza", Colors.yellow, Imza, context),
                      SilButonu("Sil", Colors.red, Sil, selectedBarcode!),

                    ],
                  ),
                ),
                Expanded(
                    child: Row(children: [
                  EkleButonu("Ekle", Colors.blue, Ekle, 3998)
                ])),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget EkleButonu(
      String text, MaterialColor renk, Function(int) action, int barkod) {
    return Expanded(
      child: Card(
        color: renk,
        child: TextButton(
          onPressed: () => action(barkod),
          child: Text(text),
        ),
      ),
    );
  }

  Widget SilButonu(
      String text, MaterialColor renk, Function(int) action, int barkod) {
    print(barkod);
    return Expanded(
      child: Card(
        color: renk,
        child: TextButton(
          onPressed: action != null ? () => action!(barkod) : null,
          child: Text(text),
        ),
      ),
    );
  }

  Widget buton(String text, MaterialColor renk, Function(BuildContext) action,
      BuildContext context) {
    return Expanded(
      child: Card(
        color: renk,
        child: TextButton(
          onPressed: () => action(context),
          child: Text(text),
        ),
      ),
    );
  }
}

class Satir extends StatelessWidget {
  final String tip;
  final String evrakno;
  final String tarih;
  final String carino;
  final String unvan;
  final String resim;
  final String imza;
  final String teslimtarihi;
  final String teslimalan;
  final String islem;
  final bool isSelected;

  Satir({
    required this.tip,
    required this.evrakno,
    required this.tarih,
    required this.carino,
    required this.unvan,
    required this.resim,
    required this.imza,
    required this.teslimtarihi,
    required this.teslimalan,
    required this.islem,
    this.isSelected = false, // Default to not selected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected ? Colors.lightBlueAccent : Colors.transparent,
      // Highlight selected item
      child: Row(
        children: [
          Blok(
            name: tip,
            width: 100,
            isSelected: isSelected,
          ),
          Blok(name: evrakno, width: 100, isSelected: isSelected),
          Blok(name: tarih, width: 100, isSelected: isSelected),
          Blok(name: carino, width: 100, isSelected: isSelected),
          Blok(name: unvan, width: 100, isSelected: isSelected),
          Blok(name: resim, width: 100, isSelected: isSelected),
          Blok(name: imza, width: 100, isSelected: isSelected),
          Blok(name: teslimtarihi, width: 100, isSelected: isSelected),
          Blok(name: teslimalan, width: 100, isSelected: isSelected),
          Blok(name: islem, width: 100, isSelected: isSelected),
        ],
      ),
    );
  }
}

class Blok extends StatelessWidget {
  double width;
  String name;
  bool isSelected;

  Blok({
    required this.name,
    required this.width,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          width: width,
          color: isSelected ? Colors.yellow : Colors.blueGrey,
          height: 30,
          child: Center(child: Text(name)),
        ));
  }
}
