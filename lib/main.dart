import 'package:flutter/material.dart';
import 'package:startingflutter/category.dart';

const _categoryName = 'Cake';
const _categoryIcon = Icons.cake;
const _categoryColor = Colors.green;
void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Measurements App'),
          ),
          body: Category(),
    ),
    );
  }
}
