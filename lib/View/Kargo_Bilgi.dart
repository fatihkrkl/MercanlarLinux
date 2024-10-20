import 'package:mercanlarlinux/View/Imza_Sayfa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KargoBilgi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hehe"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ))),
                        onPressed: () => (),
                        child: Text("Kaynak"))),
                Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ))),
                        onPressed: () => (),
                        child: Text("Kaynak"))),
                Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ))),
                        onPressed: () => (),
                        child: Text("Kaynak"))),
                Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ))),
                        onPressed: () => (),
                        child: Text("Kaynak"))),
                Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ))),
                        onPressed: () => (),
                        child: Text("Kaynak"))),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4, // Number of columns
              children: List.generate(8, (index) {
                return Center(
                  child: Text(
                    'Item $index',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                );
              }).toList(), // Ensure this is a list of Widgets
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4, // Number of columns
              children: List.generate(8, (index) {
                return Card(
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Item $index',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              }).toList(), // Ensure this is a list of Widgets
            ),
          ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ImzaSayfa()),
                                );
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue, // Border color
                                    width: 2, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                                  image: DecorationImage(
                                    image: AssetImage('assets/your_image.png'), // Your image path
                                    fit: BoxFit.cover, // Cover the entire container
                                  ),
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
                                // Define your action here
                                print('Container tapped!');
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue, // Border color
                                    width: 2, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                                  image: DecorationImage(
                                    image: AssetImage('assets/your_image.png'), // Your image path
                                    fit: BoxFit.cover, // Cover the entire container
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ))
        ]),
      ),
    );
  }
}
