import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BarkodSayfa extends StatefulWidget {
  @override
  _BarkodSayfaState createState() => _BarkodSayfaState();
}

class _BarkodSayfaState extends State<BarkodSayfa> {
  String? _selectedOption; // Variable to hold the selected option
  final List<String> _options = ["o1", "o2", "o3", "o4"]; // Options for the dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(flex:1, child: Text("Araç:")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text('Select an option'),
                      value: _selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue; // Update the selected option
                        });
                      },
                      items: _options.map<DropdownMenuItem<String>>((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex:1, child: Text("Araç:")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text('Select an option'),
                      value: _selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue; // Update the selected option
                        });
                      },
                      items: _options.map<DropdownMenuItem<String>>((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Row(
                children: [
                  Expanded(flex:1, child: Text("Araç:")),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [

                        Icon(Icons.barcode_reader),
                      ],
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex:1, child: Text("Araç:")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text('Select an option'),
                      value: _selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue; // Update the selected option
                        });
                      },
                      items: _options.map<DropdownMenuItem<String>>((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex:1, child: Text("Araç:")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text('Select an option'),
                      value: _selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue; // Update the selected option
                        });
                      },
                      items: _options.map<DropdownMenuItem<String>>((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex:1, child: Text("Araç:")),
                  Expanded(
                    flex: 2,
                    child: DropdownButton<String>(
                      hint: Text('Select an option'),
                      value: _selectedOption,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue; // Update the selected option
                        });
                      },
                      items: _options.map<DropdownMenuItem<String>>((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
