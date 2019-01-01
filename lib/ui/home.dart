import 'package:flutter/material.dart';
import 'package:watering1_app/ui/afazeres_tela.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Afazeres"),
        centerTitle: true,
        backgroundColor: Colors.black54,
      ),
      body: AfazeresTela(),
    );
  }
}
