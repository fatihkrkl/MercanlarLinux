import 'package:mercanlarlinux/Model/DatabaseHelper.dart';
import 'package:mercanlarlinux/View/Kargo_Sayfa.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/AracModel.dart';
import 'Arac_Ekle.dart';

class AracSayfa extends StatefulWidget {
  @override
  _AracSayfaState createState() => _AracSayfaState();
}

class _AracSayfaState extends State<AracSayfa> {
  Future<List<Map<String, dynamic>>> items = DatabaseHelper().fetchItems();
  DateTime? filterStartDate = DateTime(1700);
  DateTime? filterEndDate = DateTime(2100);
  String? selectedPlaka;
  String? selectedSofor;
  String? selectedPer;
  String? selectedSube;
  TextEditingController plakaController = TextEditingController();
  TextEditingController soforController = TextEditingController();
  TextEditingController perController = TextEditingController();
  TextEditingController subeController = TextEditingController();
  DateTimeRange? selectedDateRange;

  void removeItem(String plaka) async {
    print(await DatabaseHelper().fetchItems());
    try {
      setState(() {
        DatabaseHelper().deleteItem(plaka);
        items = DatabaseHelper().fetchItems();
      });
    } catch (ex) {
      // You can handle the exception or show a dialog here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Hata"),
            content: Text(ex.toString()),
            actions: [
              TextButton(
                child: Text("Tamam"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Araç Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AracEkle()),
                    ).then((val) async {
                      setState(() {
                        items = DatabaseHelper().fetchItems();
                      });
                    });
                    print('Button 1 Pressed');
                  },
                  child: const Text('Yeni'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for Button 2
                    print('Button 2 Pressed');
                  },
                  child: Text('Listele'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for Button 3
                    print('Button 3 Pressed');
                    showFilterDialog(context);
                  },
                  child: Text('Filtre'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
                child: FutureBuilder(
                    future: items,
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
                              child: Card(
                                elevation: 4,
                                child: Center(
                                  child: Arac(
                                      snapshot.data![index]['plaka'], context),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    })),
          ],
        ),
      ),
    );
  }

  Widget Arac(String plaka, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(plaka, style: TextStyle(fontSize: 18)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KargoSayfa(
                                plaka: plaka,
                              )),
                    );
                  },
                  child: Text("Görüntüle"),
                ),
                ElevatedButton(
                  onPressed: () => removeItem(plaka),
                  child: Text("Sil"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  dynamic showFilterDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: Color.fromARGB(255, 221, 221, 221),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 227, 185, 0),
                ),
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text(
                  "Uygula",
                  style: TextStyle(
                    color: Color.fromARGB(255, 96, 71, 36),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 227, 185, 117),
                ),
                onPressed: () {
                  filterStartDate = DateTime(2000);
                  filterEndDate = DateTime.now();
                  plakaController.clear();
                  selectedPlaka = null;
                },
                child: const Text(
                  "Sıfırla",
                  style: TextStyle(
                    color: Color.fromARGB(255, 96, 71, 36),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 255, 255, 255),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Filtrele",
                  style: TextStyle(
                    color: Color.fromARGB(255, 96, 71, 36),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
        content: SizedBox(
          height: 380,
          width: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dateRangeButton(context),
              SizedBox(
                height: 20,
              ),
              aracDropdownMenu()
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<Map<String, dynamic>>> aracDropdownMenu() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().fetchItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final veriler = snapshot.data!;
          return Column(
            children: [
              DropdownMenu<String>(
                controller: plakaController,
                width: 340,
                leadingIcon: const Icon(
                  Icons.abc_sharp,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                trailingIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                selectedTrailingIcon: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 53, 161, 90),
                      width: 1.5,
                    ),
                  ),
                ),
                hintText: "Plaka",
                menuStyle: MenuStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  alignment: Alignment.bottomLeft,
                  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onSelected: (String? plaka) {
                  selectedPlaka = plaka;
                },
                dropdownMenuEntries: veriler
                    .where((arac) => arac.containsKey("plaka"))
                    .fold<Map<String, Map<String, dynamic>>>(
                  {},
                      (uniqueEntries, arac) {
                    uniqueEntries[arac["plaka"]] = arac;
                    return uniqueEntries;
                  },
                )
                    .values
                    .map((arac) {
                  return DropdownMenuEntry<String>(
                    leadingIcon: const Icon(
                      Icons.groups_outlined,
                      color: Color.fromARGB(255, 96, 71, 36),
                    ),
                    label: arac["plaka"],
                    value: arac["plaka"],
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 227, 185, 117),
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 52, 52, 52),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20,),
              DropdownMenu<String>(
                controller: soforController,
                width: 340,
                leadingIcon: const Icon(
                  Icons.abc_sharp,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                trailingIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                selectedTrailingIcon: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 53, 161, 90),
                      width: 1.5,
                    ),
                  ),
                ),
                hintText: "Şoför",
                menuStyle: MenuStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  alignment: Alignment.bottomLeft,
                  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onSelected: (String? sofor) {
                  selectedSofor = sofor;
                },
                dropdownMenuEntries: veriler
                    .where((arac) => arac.containsKey("sofor"))
                    .fold<Map<String, Map<String, dynamic>>>(
                  {},
                      (uniqueEntries, arac) {
                    uniqueEntries[arac["sofor"]] = arac;
                    return uniqueEntries;
                  },
                )
                    .values
                    .map((arac) {
                  return DropdownMenuEntry<String>(
                    leadingIcon: const Icon(
                      Icons.groups_outlined,
                      color: Color.fromARGB(255, 96, 71, 36),
                    ),
                    label: arac["sofor"],
                    value: arac["sofor"],
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 227, 185, 117),
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 52, 52, 52),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20,),
              DropdownMenu<String>(
                controller: perController,
                width: 340,
                leadingIcon: const Icon(
                  Icons.abc_sharp,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                trailingIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                selectedTrailingIcon: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 53, 161, 90),
                      width: 1.5,
                    ),
                  ),
                ),
                hintText: "Personel",
                menuStyle: MenuStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  alignment: Alignment.bottomLeft,
                  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onSelected: (String? per) {
                  selectedPer = per;
                },
                dropdownMenuEntries: veriler
                    .where((arac) => arac.containsKey("per"))
                    .fold<Map<String, Map<String, dynamic>>>(
                  {},
                      (uniqueEntries, arac) {
                    uniqueEntries[arac["per"]] = arac;
                    return uniqueEntries;
                  },
                )
                    .values
                    .map((arac) {
                  return DropdownMenuEntry<String>(
                    leadingIcon: const Icon(
                      Icons.groups_outlined,
                      color: Color.fromARGB(255, 96, 71, 36),
                    ),
                    label: arac["per"],
                    value: arac["per"],
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 227, 185, 117),
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 52, 52, 52),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20,),
              DropdownMenu<String>(
                controller: subeController,
                width: 340,
                leadingIcon: const Icon(
                  Icons.abc_sharp,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                trailingIcon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                selectedTrailingIcon: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Color.fromARGB(255, 96, 71, 36),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 53, 161, 90),
                      width: 1.5,
                    ),
                  ),
                ),
                hintText: "Şube",
                menuStyle: MenuStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  alignment: Alignment.bottomLeft,
                  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onSelected: (String? sube) {
                  selectedSube = sube;
                },
                dropdownMenuEntries: veriler
                    .where((arac) => arac.containsKey("sube"))
                    .fold<Map<String, Map<String, dynamic>>>(
                  {},
                      (uniqueEntries, arac) {
                    uniqueEntries[arac["sube"]] = arac;
                    return uniqueEntries;
                  },
                )
                    .values
                    .map((arac) {
                  return DropdownMenuEntry<String>(
                    leadingIcon: const Icon(
                      Icons.groups_outlined,
                      color: Color.fromARGB(255, 96, 71, 36),
                    ),
                    label: arac["sube"],
                    value: arac["sube"],
                    style: const ButtonStyle(
                      overlayColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 227, 185, 117),
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 52, 52, 52),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error"));
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget dateRangeButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 340,
      child: ElevatedButton(
        onPressed: (() async {
          showDialog(context: context, builder: (context)=>AlertDialog(
            surfaceTintColor: Color.fromARGB(255, 221, 221, 221),
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  overlayColor: Color.fromARGB(255, 227, 185, 0),
                ),
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text(
                  "Uygula",
                  style: TextStyle(
                    color: Color.fromARGB(255, 96, 71, 36),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ));
          final dateRange = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );

          if (dateRange != null) {
            setState(() {
              filterStartDate = dateRange.start;
              filterEndDate = dateRange.end;
            });
          }
        }),
        style: ElevatedButton.styleFrom(
          overlayColor: Color.fromARGB(255, 227, 185, 117),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Color.fromARGB(255, 227, 185, 117),
              width: 1.5,
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.date_range,
              color: Color.fromARGB(255, 96, 71, 36),
            ),
            SizedBox(width: 10),
            Text(
              "Tarih Seçin",
              style: TextStyle(
                color: Color.fromARGB(255, 96, 71, 36),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
