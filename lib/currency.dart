import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyRoute extends StatefulWidget {
  @override
  _MainFetchDataState createState() => _MainFetchDataState();
}

class _MainFetchDataState extends State<CurrencyRoute> {

  bool _printMessage = false;
  String dropdownValue = 'US Dollar';
  String dropdownValue_ = 'US Dollar';
  double _inputValue;
  String _convertedValue = '';
  List<UnitIte> list = List();
  List<UnitIte> list_ = List();


  _fetchData() async {

    final response = await http.get("https://flutter.udacity.com/currency");
    if (response.statusCode == 200) {
      var object = (json.decode(response.body));
     List new_list = object['units'] as List;
     print(new_list.length);
      for(int i=0;i<new_list.length;i++){
        list_.add(new UnitIte(new_list[i]['name'], new_list[i]['conversion'].toString(), new_list[i]['description']));
      }
      setState(() {
        list = list_;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }
  @override
  void initState() {
    super.initState();
      _fetchData();

  }
  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        try {
          final inputDouble = double.parse(input);
          _printMessage = false;
          _inputValue = inputDouble;
          _updateConversion();
          print("tapped");
        } on Exception catch (e) {
          print('Error: $e');
          _printMessage = true;
        }
      }
    });
  }

  void _updateConversion(){
    double fromValue, toValue;
    for(var unit in list){
      if(unit.name == dropdownValue){
        fromValue = double.parse(unit.conversion);
      }
      if(unit.name == dropdownValue_){
        toValue = double.parse(unit.conversion);
      }
    }

      double result = _inputValue * (toValue / fromValue);
      _convertedValue = result.toString();


  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0,top: 12.0),
            child: TextField(
              style: Theme.of(context).textTheme.display1,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.display1,
                errorText: _printMessage ? 'Invalid number entered' : null,
                labelText: 'Enter the value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: _updateInputValue,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),

              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: list.map((location) {
                return DropdownMenuItem(
                  child: new Text(location.name),
                  value: location.name,
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Transform.rotate(
              angle: 90 * pi / 180,
              child: IconButton(
                icon: Icon(
                  Icons.compare_arrows,
                ),
                onPressed: null,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              child: Text(
                _convertedValue,
                style: Theme.of(context).textTheme.display1,
              ),
              decoration: InputDecoration(
                labelText: 'Output',
                labelStyle: Theme.of(context).textTheme.display1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: DropdownButton<String>(
              value: dropdownValue_,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),

              onChanged: (String newValue) {
                setState(() {
                  dropdownValue_ = newValue;
                });
              },
              items: list.map((location) {
                return DropdownMenuItem(
                  child: new Text(location.name),
                  value: location.name,
                );
              }).toList(),
            ),
          ),

        ],
      ),
    );
  }
}
class UnitIte {
   String name;
   String conversion;
   String description;
   UnitIte(String name, String conversion, String description){
     this.name = name;
     this.conversion = conversion;
     this.description = description;
   }
}
