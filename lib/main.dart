import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watering1_app/ui/home.dart';

void main() => runApp(new Afazer());

class Afazer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Watering",
      home: Home(),

    );
  }
}

