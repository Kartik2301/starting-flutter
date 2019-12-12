import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:startingflutter/converter_route.dart';
import 'package:startingflutter/currency.dart';

class Category extends StatefulWidget {
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  static const _categoryName = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];
  static const _categoryIcons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];
  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    var items = <DataItem>[];
    for (var i = 0; i < _categoryName.length; i++) {
      items.add(DataItem(_categoryIcons[i], _categoryName[i], _baseColors[i]));
    }
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () {
                  if(index ==7){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrencyRoute(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConverterRoute(),
                        settings: RouteSettings(
                          arguments: index,
                        ),
                      ),
                    );
                    print("I was tapped $index");
                  }
                },
                splashColor: Colors.red[200],
                highlightColor: Colors.black12,
                borderRadius: BorderRadius.circular(50.0 / 2),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    color: item.color,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Image.asset(item.icon,
                          height: 40.0,
                          width: 40.0,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 80.0),
                            child: Text(
                              item.content,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        body: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          padding: EdgeInsets.all(8.0),
          childAspectRatio: (itemWidth / itemHeight),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 5.0,
          children: items
              .map((data) => Container(
                    color: data.color,
                    child: InkWell(
                      splashColor: Colors.cyanAccent,
                      highlightColor: Colors.black12,
//                      onTap: () {
//                        if (data.content == 'Length') {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => ConverterRoute()));
//                        }
//                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60.0),
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Center(
                                child: Icon(
                                  Icons.cake,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Center(
                                  child: Text(
                                    data.content,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    }
  }
}

class DataItem {
  @required
  String icon;
  @required
  String content;
  Color color;
  DataItem(String icon, String content, Color color) {
    this.icon = icon;
    this.content = content;
    this.color = color;
  }
}
