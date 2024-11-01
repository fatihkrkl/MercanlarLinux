import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Kargo_Ekle.dart';
import 'package:mercanlarlinux/View/Kargo_Sayfa.dart';

import '../Model/DatabaseHelper.dart';

class AracEkle extends StatefulWidget {

  AracEkle({super.key});

  @override
  Combo_Iki_State createState() => Combo_Iki_State();
}

class Combo_Iki_State extends State<AracEkle> {
  String? selectedValue ;
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
              Row(
                children: [
                  Expanded(flex: 1, child: Text("Araç")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text("Select"),
                      value: selectedValue, // Displays the last selected value
                      items: options.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue;
                          print("Selected: $selectedValue");
                        });
                      },
                    )

                  )
                ],
              ),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: selectedValue == null
                    ? null // Disables the button when selectedValue is null
                    : () async {
                  Navigator.pop(context);
                  String id = await DatabaseHelper().insertItemD();
                  print("value: $selectedValue");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KargoSayfa(id: id, plaka: selectedValue!,nav: true,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedValue == null ? Colors.transparent : Colors.blue,
                  foregroundColor: selectedValue == null ? Colors.grey : Colors.white,
                  shadowColor: selectedValue == null ? Colors.transparent : null,
                ),
                child: Text("Kaydet"),
              )

            ],
          ),
        ));
  }
}

