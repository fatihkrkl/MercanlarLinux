import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Resim_Sayfa.dart';

class KargoEkle extends StatefulWidget {
  @override
  Combo_Bir_State createState() => Combo_Bir_State();
}

class Combo_Bir_State extends State<KargoEkle> {
  int selectedValue = 0;
  final List<String> options = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
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
                  Expanded(flex: 1,child: Text("Araç")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text("Select"),
                      items:
                          options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          var selectedValue = newValue;
                          print(selectedValue);
                        });
                      },
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Expanded(flex: 1,child: Text("Araç")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text("Select"),
                      items:
                          options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          var selectedValue = newValue;
                          print(selectedValue);

                        });
                      },
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Expanded(child: Text("Araç")),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(hintText: "Barkod"),
                  )),
                  Expanded(child: IconButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ResimSayfa(imza: true)),),
                      icon: Icon(Icons.barcode_reader)))
                ],
              )),
              const Expanded(
                  child: Row(
                children: [
                  Expanded(flex: 1,child: Text("Araç")),
                  Expanded(
                      flex: 2,
                      child: TextField(
                    decoration: InputDecoration(hintText: "Tarih"),
                  ))
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Expanded(flex: 1,child: Text("Araç")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text("Select"),
                      items:
                          options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          var selectedValue = newValue;
                        });
                      },
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Row(
                children: [
                  Expanded(flex: 1,child: Text("Araç")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text("Select"),
                      items:
                          options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          var selectedValue = newValue;
                          print(selectedValue);

                        });
                      },
                    ),
                  )
                ],
              )),
              Expanded(child: ElevatedButton(onPressed: ()=>
              Navigator.pop(context), child: Text("Kaydet")))
            ],
          ),
        ));
  }
}
