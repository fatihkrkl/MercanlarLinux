import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:mercanlarlinux/Model/DatabaseHelper.dart';
import 'package:mercanlarlinux/View/Kargo_Sayfa.dart';
import 'package:flutter/material.dart';

import 'Arac_Ekle.dart';

class AracSayfa extends StatefulWidget {
  @override
  _AracSayfaState createState() => _AracSayfaState();
}

class _AracSayfaState extends State<AracSayfa> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> list = [];
  DateTime filterStartDate = DateTime.now().subtract(Duration(days: 1));
  DateTime filterEndDate = DateTime.now();
  String? selectedPlaka;
  String? selectedSofor;
  String? selectedPer;
  String? selectedSube;
  TextEditingController plakaController = TextEditingController();
  TextEditingController soforController = TextEditingController();
  TextEditingController perController = TextEditingController();
  TextEditingController subeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    items = [];
    (await DatabaseHelper().fetchItems()).forEach((item) {
      items.add(item);
    });
    applyFilter();
    setState(() {}); // Update the UI after fetching items
  }

  void removeItem(String id) async {
    try {
      setState(() {
        DatabaseHelper().deleteItem(id);
        items.removeWhere((item) => item['id'] == id);
        applyFilter();
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

  void applyFilter() {
    list = [];
    items.forEach((item) {
      int year = (int.parse((item['tarih'] as String).split("-")[0]));
      int month = (int.parse((item['tarih'] as String).split("-")[1]));
      int day = (int.parse((item['tarih'] as String).split("-")[2]));
      DateTime date = DateTime(year, month, day);
      if ((item['plaka'] == selectedPlaka || selectedPlaka == null) &&
          (item['sofor'] == selectedSofor || selectedSofor == null) &&
          (item['sube'] == selectedSube || selectedSube == null) &&
          (item['per'] == selectedPer || selectedPer == null) &&
          (!date.isAfter(filterEndDate) && !filterStartDate.isAfter(date))) {
        list.add(item);
      }
    });
  }

  Future<void> _Ekle() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AracEkle()),
    ).then((val) async {
      fetchItems();
    });
  }
  void _Listele(){
    setState(() {
      list = items;
      filterStartDate = DateTime(2000);
      filterEndDate = DateTime.now();
      plakaController.clear();
      subeController.clear();
      soforController.clear();
      perController.clear();
      selectedSofor = null;
      selectedPlaka = null;
      selectedSube = null;
      selectedPer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araç Sayfası'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Buton(context, "Ekle",_Ekle,Colors.blue,Colors.white),
                Buton(context,"Listele",_Listele,Colors.lightBlueAccent,Colors.white),
                Buton(context, "Filtrele", () =>showFilterDialog(context), Colors.yellow, Colors.white)
              ],
            ),
            SizedBox(height: 16),
            Expanded(
                child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 100,
                  child: Card(
                    elevation: 4,
                    child: Center(
                      child:
                          Arac(list[index]['id'], list[index]['id'], context),
                    ),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  Card Buton(BuildContext context,String text , VoidCallback action,Color bg, Color txt) {
    return Card(
      color: bg,
      child: InkWell(
        onTap: () async => action(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: txt, // Text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget Arac(String plaka, String id, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            id.length > 9 ? 'Fiş\n#${id.substring(0, 9)}...' : 'Fiş\n#$id',
            style: const TextStyle(fontSize: 18),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Buton(context, "Görüntüle", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => KargoSayfa(
                          id: id,
                          plaka: plaka,
                        )),
                  );
                }, Colors.green, Colors.white),
                Buton(context, "Sil", () => removeItem(id), Colors.red, Colors.white),
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
                  Navigator.pop(context);
                },
                child: const Text(
                  "Kapat",
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
                  setState(() {
                    applyFilter();
                  });
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

  Widget aracDropdownMenu() {
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
          dropdownMenuEntries: items
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
              })
              .toList(),
        ),
        SizedBox(
          height: 20,
        ),
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
          dropdownMenuEntries: items
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
              })
              .toList(),
        ),
        SizedBox(
          height: 20,
        ),
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
          dropdownMenuEntries: items
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
              })
              .toList(),
        ),
        SizedBox(
          height: 20,
        ),
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
          dropdownMenuEntries: items
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
              })
              .toList(),
        ),
      ],
    );
  }

  Widget dateRangeButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 340,
      child: ElevatedButton(
        onPressed: (() async {
          showCustomDateRangePicker(
            context,
            dismissible: true,
            minimumDate: DateTime.now().subtract(const Duration(days: 30)),
            maximumDate: DateTime.now().add(const Duration(days: 30)),
            endDate: filterEndDate,
            startDate: filterStartDate,
            backgroundColor: Colors.white,
            primaryColor: Color.fromARGB(255, 236, 203, 82),
            onApplyClick: (start, end) {
              setState(() {
                filterEndDate = end;
                filterStartDate = start;
              });
            },
            onCancelClick: () {
              setState(() {});
            },
          );
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
