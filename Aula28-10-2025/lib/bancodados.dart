import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoDados {
  static final BancoDados instance = BancoDados._init();
  static Database? _banco;
  BancoDados._init();

  Future<Database> get database async {
    if (_banco != null) return _banco!;
    _banco = await _inicializarBanco('calculadora.db');
    return _banco!;
  }

  Future<Database> _inicializarBanco(String arquivo) async {
    final caminho = await getDatabasesPath();
    final path = join(caminho, arquivo);
    return await openDatabase(path, version: 1, onCreate: _criarBanco);
  }

  Future _criarBanco(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE dados (
        id INTEGER PRIMARY KEY,
        valorVisor TEXT,
        valorMemoria REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE operacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricaoOperacao TEXT,
        dataHora TEXT
      )
    ''');

    await db.insert('dados', {'id': 1, 'valorVisor': '0', 'valorMemoria': 0.0});
  }

  Future<Map<String, dynamic>> carregarEstado() async {
    final db = await instance.database;
    final resultado = await db.query('dados', where: 'id = ?', whereArgs: [1]);
    return resultado.first;
  }

  Future<void> salvarEstado(String visor, double memoria) async {
    final db = await instance.database;
    await db.update(
      'dados',
      {'valorVisor': visor, 'valorMemoria': memoria},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> salvarOperacao(String descricao) async {
    final db = await instance.database;
    await db.insert('operacoes', {
      'descricaoOperacao': descricao,
      'dataHora': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> obterOperacoes() async {
    final db = await instance.database;
    return await db.query('operacoes', orderBy: 'id DESC');
  }
}
