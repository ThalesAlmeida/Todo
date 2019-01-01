import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:watering1_app/modelos/afazer.dart';


class DbAjudante{
  static final DbAjudante _instance = new DbAjudante.internal();

  factory DbAjudante() => _instance;

  final String nomeTabela = "afazerTabela";
  final String colunaId = "id";
  final String afazerNome = "nome";
  final String afazerDataCriado = "data";

  static Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initBd();
    return _db;
  }

  DbAjudante.internal();

  initBd() async {
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();
    String caminho = join(documentoDiretorio.path, "bd_principal.db"); // home://directory/files/bd_principal.db

    var nossoBD = await openDatabase(caminho, version: 1, onCreate: _onCreate);
    return nossoBD;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $nomeTabela($colunaId INTEGER PRIMARY KEY,"
        "$afazerNome REAL,"
        "$afazerDataCriado REAL)");
  }

  //CRUD - CREATE, READ, UPDATE, DELETE

  //INSERIR
  Future<int> salvarAfazer(Afazer afazer) async {
    var bdCliente = await db;
    int res = await bdCliente.insert("$nomeTabela", afazer.toMap());
    print(res.toString());
    return res;
  }

  //Pegar usuario atravez da sua ID
  Future<List> recuperarTodosAfazeres() async {
    var bdCliente = await db;
    var res = await bdCliente.rawQuery("SELECT * FROM $nomeTabela"
        " ORDER BY $afazerNome ASC");

    return res.toList();
  }

  //Contagem
  Future<int> contagem() async {
    var bdCliente = await db;
    return Sqflite.firstIntValue(
        await bdCliente.rawQuery("SELECT COUNT(*) FROM $nomeTabela"));
  }

  //Pegar usuario atravez da sua ID
  Future<Afazer> recuperarAfazer(int id) async {
    var bdCliente = await db;
    var res = await bdCliente.rawQuery("SELECT * FROM $nomeTabela"
        " WHERE $colunaId = $id");
    if (res.length == 0) return null;
    return new Afazer.fromMap(res.first);
  }

  //Apagar or deletar
  Future<int> apagarUsuario(int id) async {
    var bdCliente = await db;

    return await bdCliente.delete(nomeTabela,
        where: "$colunaId = ?", whereArgs: [id]);
  }

  //Atualizar usuario

  Future<int> atualizarUsuario(Afazer afazer) async {
    var bdCliente = await db;
    return await bdCliente.update(nomeTabela,
        afazer.toMap(), where: "$colunaId = ?", whereArgs: [afazer.id]);
  }

}