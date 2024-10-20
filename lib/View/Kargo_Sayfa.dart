import 'package:mercanlarlinux/View/Kargo_Bilgi.dart';
import 'package:flutter/material.dart';
import 'package:mercanlarlinux/View/Kargo_Ekle.dart';
class KargoSayfa extends StatelessWidget{
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Sayfası'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KargoEkle()),
          );
          // Action to be performed on button press
        },
        child: Icon(Icons.add), // Plus icon
        tooltip: 'Add',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 100,
                child: Kargo(items[index],context),
              );
            },
          )
          ,
        ),
      ),
    );
  }
  Widget Kargo(data,context){
    return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Adjust border radius
            side: BorderSide(
              color: Colors.blue, // Set border color
              width: 2, // Set border width
            ),
          ),
        ),
        onPressed: () =>Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KargoBilgi()),
        ),
        child: Row(
          children: [
            Expanded(child: Text("Tip")),
            Expanded(child: Text("Evrak")),
            Expanded(child: Text("Tarih")),
            Expanded(child: Text("CariNo")),
            Expanded(child: Text("Unvan")),
            Expanded(child: Text("Resim")),
            Expanded(child: Text("İmza")),
            Expanded(child: Text("Teslim Tarihi")),
            Expanded(child: Text("Teslim Alan")),
            Expanded(child: Text("İşlem")),
          ],
        )
    );
  }
}