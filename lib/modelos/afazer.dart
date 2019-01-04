import 'package:flutter/material.dart';

class Afazer extends StatelessWidget {
  String afazerNome;
  String afazerDataCriado;
  double salario;
  int id;

  Afazer({this.afazerNome, this.afazerDataCriado, this.salario});

  Afazer.map(dynamic obj) {
    this.afazerNome = obj["nome"];
    this.afazerDataCriado = obj["data"];
    this.id = obj["id"];
    this.salario = obj["salario"];
  }

  String get _afazerNome => afazerNome;

  String get _afazerDataCriado => afazerDataCriado;

  double get _salario => salario;

  int get _id => id;

  Map<String, dynamic> toMap() {
    var mapa = new Map<String, dynamic>();
    mapa["nome"] = afazerNome;
    mapa["data"] = afazerDataCriado;
    mapa["salario"] = salario;

    if (_id != null) {
      mapa["id"] = _id;
    }

    return mapa;
  }

  Afazer.fromMap(Map<String, dynamic> mapa) {
    this.afazerNome = mapa["nome"];
    this.afazerDataCriado = mapa["data"];
    this.id = mapa["id"];
    this.salario = double.parse(mapa["salario"]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _afazerNome,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9),
          ),
          Text(
            _salario.toString(),
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: Text(
              "$_afazerDataCriado",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );
  }
}
