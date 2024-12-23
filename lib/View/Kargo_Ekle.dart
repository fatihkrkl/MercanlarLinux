import 'package:flutter/material.dart';
import 'package:mercanlarlinux/Model/DatabaseHelper.dart';

class KargoEkle extends StatefulWidget {
  final String id;
  const KargoEkle({super.key, required this.id});
  @override
  ComboState createState() => ComboState();
}

class ComboState extends State<KargoEkle> {
  TextEditingController barkodController= TextEditingController();
  String? selectedSofor;
  String? selectedPer;
  String? selectedSube;
  FocusNode barkodFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(barkodFocusNode);
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    FocusScope.of(context).requestFocus(barkodFocusNode);
  }

  @override
  void dispose() {
    barkodFocusNode.dispose(); // Step 4: Dispose the FocusNode
    super.dispose();
  }

  final List<String> soforler = [
    'Şoför 1',
    'Şoför 2',
    'Şoför 3',
    'Şoför 4',
  ];
  final List<String> perler = [
    'Personel 1',
    'Personel 2',
    'Personel 3',
    'Personel 4',
  ];
  final List<String> subeler = [
    'Şube 1',
    'Şube 2',
    'Şube 3',
    'Şube 4',
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ekle"),
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: [
              Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 1,child: Text("Şoför")),
                      Expanded(
                        flex: 2,
                        child: DropdownButton<String>(
                          hint: Text("Şoför Seçin"),
                          value: selectedSofor,
                          items:
                          soforler.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSofor = newValue;
                            });
                          },
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      Expanded(child: Text("Barkod")),
                      Expanded(
                          child: TextField(
                            focusNode: barkodFocusNode,
                            controller: barkodController,
                            decoration: InputDecoration(hintText: "Barkod"),
                          )),
                      Expanded(child: IconButton(onPressed: ()=> (/* Terminal barkod okuyucu çalıştır */),
                          icon: Icon(Icons.barcode_reader)))
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 1,child: Text("Personel")),
                      Expanded(
                        flex: 2,
                        child: DropdownButton<String>(
                          hint: Text("Personel Seçin"),
                          value: selectedPer,
                          items:
                          perler.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPer = newValue;
                            });
                          },
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 1,child: Text("Şube")),
                      Expanded(
                        flex: 2,
                        child: DropdownButton<String>(
                          hint: Text("Şube Seçin"),
                          value: selectedSube,
                          items:
                          subeler.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedSube = newValue;

                            });
                          },
                        ),
                      )
                    ],
                  )),
              Card(
                child: TextButton(
                  onPressed: () async {
                    await DatabaseHelper().insertKargoD(barkodController.text, widget.id);
                    Navigator.pop(context,true);
                  },
                  child: Text("Kaydet"),
                ),
              ),

            ],
          ),
        ));
  }
}