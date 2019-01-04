import 'package:flutter/material.dart';
import 'package:watering1_app/modelos/afazer.dart';
import 'package:watering1_app/ui/cadastro_afazer.dart';
import 'package:watering1_app/util/db_ajudante.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AfazeresTela extends StatefulWidget {
  @override
  _AfazeresTelaState createState() => _AfazeresTelaState();
}

class _AfazeresTelaState extends State<AfazeresTela> {
  final TextEditingController _control = new TextEditingController();
  final TextEditingController _controlVezes = new TextEditingController();

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _name;
  double _salario;

  var db = new DbAjudante();

  final List<Afazer> _afazerLista = <Afazer>[];

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
        db.salvarAfazer(afazer);
      });
    }
  }

  @override
  void initState() {
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
                itemCount: _afazerLista.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (_, int posicao) {
                  return Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: _afazerLista[posicao],
                      onLongPress: () =>
                          _atualizarAfazer(_afazerLista[posicao], posicao),
                          trailing: Listener(
                            key: Key(_afazerLista[posicao].afazerNome),
                            child: Icon(Icons.remove_circle,
                            color: Colors.white,),
                            onPointerDown: (pointerEvento) => _apagarAfazer(_afazerLista[posicao].id, posicao),
                          ),
                    ),
                  );
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: ListTile(
            title: Icon(Icons.add),
          ),
          onPressed: _mostrarFormulario),
    );
  }

  void _pegarAfazeres() async {
    List afazeres = await db.recuperarTodosAfazeres();
    afazeres.forEach((item) {
      setState(() {
        if (afazeres == null) {
          Text("Nada");
        }
        _afazerLista.add(Afazer.map(item));
      });
    });
  }

  void _mostrarFormulario() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>AfazerPage())
    );
  }

//  void _lidarComtexto(String text, double vezes) async {
//    _control.clear();
//
//    Afazer afazer = new Afazer(text, dataFormatada(), vezes);
//
//    int salvoId = await db.salvarAfazer(afazer);
//
//    Afazer itemSalvo = await db.recuperarAfazer(salvoId);
//    setState(() {
//      _afazerLista.insert(0, itemSalvo);
//    });
//  }

  String dataFormatada() {
    var agora = DateTime.now();
    initializeDateFormatting("pt_BR", null);
    var formatador = new DateFormat.yMMMd("pt_BR");

    return formatador.format(agora);
  }

  _atualizarAfazer(Afazer afazer, int posicao) {
    var alert = AlertDialog(
      title: Text("Atualizar Afazer"),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _control,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Afazer", icon: Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              Afazer atualizarItem = Afazer.fromMap({
                "nome": _control.text,
                "data": dataFormatada(),
                "id": afazer.id
              });

              _lidarComAtualizacao(posicao, afazer);
              await db.atualizarAfazer(atualizarItem);

              setState(() {
                  _pegarAfazeres();
                  Navigator.pop(context);
              });
            },
            child: Text("Atualizar")),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancelar"),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _lidarComAtualizacao(int posicao, Afazer afazer) {
    setState(() {
      _afazerLista.removeWhere((elemento) {
        _afazerLista[posicao].afazerNome == afazer.afazerNome;
      });
    });
  }

  _apagarAfazer(int id, int posicao) async {
    await db.apagarAfazer(id);
    setState(() {
      _afazerLista.removeAt(posicao);
    });
  }
}
