import 'package:flutter/material.dart';
import 'package:watering1_app/modelos/afazer.dart';
import 'package:watering1_app/util/db_ajudante.dart';

class AfazeresTela extends StatefulWidget {
  @override
  _AfazeresTelaState createState() => _AfazeresTelaState();
}

class _AfazeresTelaState extends State<AfazeresTela> {

  final TextEditingController _control = new TextEditingController();

  var db = new DbAjudante();

  final List<Afazer> _afazerLista = <Afazer>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pegarAfazeres();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                itemBuilder: (_, int posicao){
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: _afazerLista[posicao],
                      onLongPress: () => debugPrint("LongPress"),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _mostrarFormulario()
      ),
    );
  }

  void _pegarAfazeres() async {
    List afazeres = await db.recuperarTodosAfazeres();
    afazeres.forEach((item){
        setState(() {
          _afazerLista.add(Afazer.map(item));
        });
    });
  }

  _mostrarFormulario() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _control,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Afazer",
                hintText: "Algo a afazer",
                icon: Icon(Icons.note_add)
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          debugPrint("");
        },
          child: Text("Salvar"),)
      ],
    );
    showDialog(context: context,
    builder: (_){
      return alert;
    });

  }
}
