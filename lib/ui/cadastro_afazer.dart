import 'dart:io';

import 'package:watering1_app/util/db_ajudante.dart';
import 'package:flutter/material.dart';
import 'package:watering1_app/modelos/afazer.dart';


class AfazerPage extends StatefulWidget {
  @override
  _AfazerPageState createState() => _AfazerPageState();
}

class _AfazerPageState extends State<AfazerPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _name;
  double _salario;

  final _nameFocus = FocusNode();

  bool _userEdited = false;



  void _submit(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();

      Afazer afazer = new Afazer(
        afazerNome: _name,
        salario: _salario,
      );
      setState(() {
        var db = new DbAjudante();
        db.salvarAfazer(afazer).then((res){
          _showSnackBar("Dados Salvos");
          new Future.delayed(new Duration(seconds: 4)).then((_){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>AfazerPage())
            );
          });
        })
            .catchError((err) {
          _showSnackBar('Error: $err');
        });
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _submit,
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),

              ),
//              TextField(
//                focusNode: _nameFocus,
//                decoration: InputDecoration(labelText: "Nome"),
//                onChanged: (text){
//                  _userEdited = true;
//                  setState(() {
//                    _editedContact.name = text;
//                  });
//                },
//              ),
              new Form(
                  key: formKey,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          controller: _nameController,
                          onSaved: (val) => _name = val,
                          validator: (val) {
                            return val.length < 1
                                ? "Name must have atleast 1 chars"
                                : null;
                          },
                          decoration: new InputDecoration(labelText: "Nome"),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          onSaved: (val) => _salario = double.parse(val),
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(labelText: "Salário"),
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}
