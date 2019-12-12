import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'dart:math';
import 'dart:async';

class ConverterRoute extends StatefulWidget {
  _converterRouteState createState() => _converterRouteState();

}

class _converterRouteState extends State<ConverterRoute> {
  List<UnitItem> _UnitsList = List<UnitItem>();
  double _inputValue;

  bool _printMessage = false;
  String dropdownValue = 'Choose Unit';
  String dropdownValue_ = 'Choose Unit';
  String _convertedValue = '';
  void initState() {
    super.initState();

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
     for(var unit in _UnitsList){
       if(unit.name == dropdownValue){
         fromValue = unit.conversion;
       }
       if(unit.name == dropdownValue_){
         toValue = unit.conversion;
       }
     }
     if(dropdownValue == "Choose Unit"|| dropdownValue_ =="Choose Unit"){
       _convertedValue =" ";
     }
     else {
       double result = _inputValue * (toValue / fromValue);
       _convertedValue = result.toString();
     }

  }
  Future<String> _loadCrosswordAsset() async {
    return await rootBundle.loadString('assets/data/regular_units.json');
  }
  Future loadCrossword(String pass) async {
    String jsonCrossword = await _loadCrosswordAsset();
    _parseJsonForCrossword(jsonCrossword, pass);
  }
  void _parseJsonForCrossword(String jsonString, String pass) {
    List<UnitItem> _unitList = List<UnitItem>();

    Map decoded = jsonDecode(jsonString);
    for (var word in decoded[pass]) {
        _unitList.add(new UnitItem(word['name'], word['conversion']));
    }
    setState(() {
      _UnitsList = _unitList;
    });
  }
    @override
  Widget build(BuildContext context) {
      final int value = ModalRoute.of(context).settings.arguments;
      setState(() {
        if(value ==0){
          loadCrossword("Length");
        }
        else if(value ==1){
          loadCrossword("Area");
        }
        else if(value ==2){
          loadCrossword("Volume");
        }
        else if(value ==3){
          loadCrossword("Mass");
        }
        else if(value ==4){
          loadCrossword("Time");
        }
        else if(value ==5){
          loadCrossword("Digital Storage");
        }
        else if(value ==6){
          loadCrossword("Energy");
        }
      });
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
             items: _UnitsList.map((location) {
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
              items: _UnitsList.map((location) {
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
class UnitItem{
  String name;
  double conversion;
  UnitItem(String name, double conversion){
    this.name = name;
    this.conversion = conversion;
  }
}