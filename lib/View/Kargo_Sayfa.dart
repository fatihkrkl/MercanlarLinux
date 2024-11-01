import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Kargo_Ekle.dart';
import 'package:mercanlarlinux/View/Resim_Sayfa.dart';
import '../Model/DatabaseHelper.dart';
import 'Imza_Sayfa.dart';

class KargoSayfa extends StatefulWidget {
  final String id;
  final String plaka;
  final bool nav;

  const KargoSayfa({required this.id, required this.plaka, this.nav = false});

  @override
  _KargoSayfaState createState() => _KargoSayfaState();
}

class _KargoSayfaState extends State<KargoSayfa> {
  late Future<List<Map<String, dynamic>>> kargoItems;
  int? selectedIndex; // Track selected item index
  String selectedBarcode = "";

  @override
  void initState() {
    super.initState();
    kargoItems = DatabaseHelper().fetchKargo(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.nav) {
        Ekle();
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    kargoItems = DatabaseHelper().fetchKargo(widget.id);
  }

  void static;

  refreshItems() {
    setState(() {
      kargoItems = DatabaseHelper().fetchKargo(widget.id);
    });
  }

  void Deneme(BuildContext context) {
    print("dsadsa");
  }

  void Ekle() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KargoEkle(id: widget.id)),
    );
    if (result == true) {
      // Check if the result is true
      setState(() {
        refreshItems(); // Refresh items if the result is true
        Ekle();
      });
    }
  }

  void Sil(String barkod) async {
    selectedIndex != null ? await DatabaseHelper().deleteKargo(barkod) : ();
    selectedIndex = null;
    selectedBarcode = "";
    refreshItems();
  }

  void Imza(BuildContext context) {
    selectedIndex != null
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => ImzaSayfa()))
        : ();
  }

  void Resim(BuildContext context) {
    selectedIndex != null
        ? Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResimSayfa()))
        : ();
  }

  @override
  Widget build(BuildContext context) {
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
                  tip: "Tip",
                  evrakno: "Evrak No",
                  tarih: "Tarih",
                  carino: "Cari No",
                  unvan: "Unvan",
                  resim: "Resim",
                  imza: "İmza",
                  teslimtarihi: "Teslim Tarihi",
                  teslimalan: "Teslim Alan",
                  islem: "İşlem",
                  anaArkaRenk: Color.fromARGB(255, 152, 152, 152),
                  anaYaziRenk: Colors.white,
                ),
                SizedBox(
                  width: 1000,
                  height: screenHeight - 235,
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
                                tip: veri["barkod"],
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
                          opacity: 0.5, // Set opacity to make it transparent
                          child: Row(
                            children: [
                              buton("Resim", Color.fromARGB(171, 27, 248, 75),Colors.black, Resim, context),
                              buton("İmza", Colors.yellow,Colors.black, Imza, context),
                              SilButonu(
                                  "Sil", Colors.red,Colors.white, Sil, selectedBarcode),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            buton("Resim", Color.fromARGB(171, 27, 248, 75),Colors.black ,Resim, context),
                            buton("İmza", Colors.yellow,Colors.black, Imza, context),
                            SilButonu("Sil", Colors.red,Colors.white, Sil, selectedBarcode),
                          ],
                        ),
                ),
                Expanded(
                    child:
                        Row(children: [EkleButonu("Ekle", Colors.blue,Colors.white, Ekle)])),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget EkleButonu(String text, MaterialColor renk,Color yazi, Function() action) {
    return Expanded(
      child: Card(
        color: renk,
        child: TextButton(
          onPressed: () => action(),
          child: Text(text,style: TextStyle(color: yazi),),
        ),
      ),
    );
  }

  Widget SilButonu(
      String text, MaterialColor renk,Color yazi, Function(String) action, String barkod) {
    return Expanded(
      child: Card(
        color: renk,
        child: TextButton(
          onPressed: () => action(barkod),
          child: Text(text,style: TextStyle(color: yazi),),
        ),
      ),
    );
  }

  Widget buton(String text, Color renk,Color yazi, Function(BuildContext) action,
      BuildContext context) {
    return Expanded(
      child: Card(
        color: renk,
        child: TextButton(
          onPressed: () => action(context),
          child: Text(text,style: TextStyle(color: yazi),),
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

  final Color anaArkaRenk;
  final Color anaYaziRenk;
  final Color seciliArkaRenk;
  final Color seciliYaziRenk;

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
    this.anaArkaRenk = const Color.fromARGB(213, 220, 220, 220),
    this.anaYaziRenk = const Color.fromARGB(255, 0, 0, 0),
    this.seciliArkaRenk = const Color.fromARGB(255, 179, 179, 179),
    this.seciliYaziRenk = const Color.fromARGB(255, 237, 237, 237),
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final values = [
      tip,
      evrakno,
      tarih,
      carino,
      unvan,
      resim,
      imza,
      teslimtarihi,
      teslimalan,
      islem,
    ];

    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: values
            .map((value) => Blok(
                  name: value,
                  width: 100,
                  isSelected: isSelected,
                  anaArkaRenk: anaArkaRenk,
                  anaYaziRenk: anaYaziRenk,
                  seciliArkaRenk: seciliArkaRenk,
                  seciliYaziRenk: seciliYaziRenk,
                ))
            .toList(),
      ),
    );
  }
}

class Blok extends StatelessWidget {
  final double width;
  final String name;
  final bool isSelected;
  final Color anaArkaRenk;
  final Color anaYaziRenk;
  final Color seciliArkaRenk;
  final Color seciliYaziRenk;

  const Blok({
    required this.name,
    required this.width,
    required this.isSelected,
    this.anaArkaRenk = const Color.fromARGB(200, 200, 200, 200),
    this.anaYaziRenk = const Color.fromARGB(200, 0, 0, 0),
    this.seciliArkaRenk = const Color.fromARGB(200, 80, 74, 71),
    this.seciliYaziRenk = const Color.fromARGB(200, 41, 41, 41),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: isSelected ? seciliArkaRenk : anaArkaRenk,
      height: 30,
      child: Center(
        child: Text(
          name,
          style: TextStyle(color: isSelected ? seciliYaziRenk : anaYaziRenk),
        ),
      ),
    );
  }
}
