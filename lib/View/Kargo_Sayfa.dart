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
  int? _selectedIndex;
  int? _selectedRowIndex; // Track the selected row index
  late Future<List<Map<String, dynamic>>> kargoItems; // Future for fetching kargo items

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
  void selectRow(int index) {
    setState(() {
      _selectedRowIndex = index; // Set the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kargo Sayfası'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 5000,
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
              ),
              itemCount: 50,
              shrinkWrap: true, // Prevents unbounded height issues
              physics: const NeverScrollableScrollPhysics(), // Disable vertical scroll
              itemBuilder: (context, index) {
                int rowIndex = index ~/ 5;

                return GestureDetector(
                  onTap: () => selectRow(rowIndex), // Select a row
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    color: _selectedRowIndex == rowIndex ? Colors.blueAccent : Colors.grey,
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 2000,
                        child: Text(
                          'Row $rowIndex',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                        child: Kargo(snapshot.data![index]['barkod'], context, index),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
          // Other widgets remain the same
        ],
      ),
    );
  }


  Widget Kargo(dynamic data, BuildContext context, int index) {
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
            children: List.generate(9, (i) => Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                '$data',
                style: TextStyle(
                  color: _selectedIndex == index
                      ? Colors.white // Selected item text color
                      : Colors.black, // Default text color
                  fontSize: 18,
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
