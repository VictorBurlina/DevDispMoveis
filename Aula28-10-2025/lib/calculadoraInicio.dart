import 'package:flutter/material.dart';
import 'bancodados.dart';
import 'historico.dart';

class TelaCalculadora extends StatefulWidget {
  const TelaCalculadora({super.key});

  @override
  State<TelaCalculadora> createState() => _TelaCalculadoraEstado();
}

class _TelaCalculadoraEstado extends State<TelaCalculadora> {
  String _valorVisor = '0';
  double _valorMemoria = 0.0;
  double? _primeiroOperando;
  String? _operacao;
  bool _digitandoSegundoOperando = false;

  final banco = BancoDados.instance;

  @override
  void initState() {
    super.initState();
    _carregarEstado();
  }

  Future<void> _carregarEstado() async {
    try {
      final estado = await banco.carregarEstado();
      setState(() {
        _valorVisor = estado['valorVisor'];
        _valorMemoria = estado['valorMemoria'];
      });
    } catch (e) {
      _salvarEstado();
    }
  }

  Future<void> _salvarEstado() async {
    await banco.salvarEstado(_valorVisor, _valorMemoria);
  }

  Future<void> _salvarOperacao(String descricao) async {
    await banco.salvarOperacao(descricao);
  }

  void _botaoPressionado(String texto) {
    setState(() {
      switch (texto) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case '.':
          _tratarNumero(texto);
          break;

        case '+':
        case '-':
        case '*':
        case '/':
          _tratarOperacao(texto);
          break;

        case '=':
          _tratarIgual();
          break;

        case 'C':
          _limparTudo();
          break;

        case 'MC':
          _valorMemoria = 0.0;
          break;
        case 'MR':
          _valorVisor = _valorMemoria.toString();
          _digitandoSegundoOperando = true;
          break;
        case 'M+':
          _valorMemoria += double.parse(_valorVisor);
          break;
        case 'M-':
          _valorMemoria -= double.parse(_valorVisor);
          break;
      }
    });
    _salvarEstado();
  }

  void _tratarNumero(String numero) {
    if (_digitandoSegundoOperando) {
      _valorVisor = numero;
      _digitandoSegundoOperando = false;
    } else if (_valorVisor == '0') {
      _valorVisor = numero == '.' ? '0.' : numero;
    } else if (numero == '.' && _valorVisor.contains('.')) {
      return;
    } else {
      _valorVisor += numero;
    }
  }

  void _tratarOperacao(String op) {
    _primeiroOperando = double.parse(_valorVisor);
    _operacao = op;
    _digitandoSegundoOperando = true;
  }

  void _tratarIgual() {
    if (_primeiroOperando == null ||
        _operacao == null ||
        _digitandoSegundoOperando) {
      return;
    }

    final double segundoOperando = double.parse(_valorVisor);
    double resultado = 0.0;

    switch (_operacao) {
      case '+':
        resultado = _primeiroOperando! + segundoOperando;
        break;
      case '-':
        resultado = _primeiroOperando! - segundoOperando;
        break;
      case '*':
        resultado = _primeiroOperando! * segundoOperando;
        break;
      case '/':
        if (segundoOperando == 0) {
          _valorVisor = 'Erro';
          return;
        }
        resultado = _primeiroOperando! / segundoOperando;
        break;
    }

    String logOperacao =
        "$_primeiroOperando $_operacao $segundoOperando = $resultado";
    _salvarOperacao(logOperacao);

    _valorVisor = resultado.toString();
    _primeiroOperando = null;
    _operacao = null;
    _digitandoSegundoOperando = true;
  }

  void _limparTudo() {
    _valorVisor = '0';
    _primeiroOperando = null;
    _operacao = null;
    _digitandoSegundoOperando = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora SQLite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TelaHistorico()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Visor
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _valorMemoria == 0.0 ? '' : 'Memória: $_valorMemoria',
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  _valorVisor,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _linhaBotoes(['MC', 'MR', 'M-', 'M+'], memoria: true),
                  _linhaBotoes(['C', '/', '*', '-'], operador: true),
                  Expanded(
                    flex: 2,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              _linhaBotoes(['7', '8', '9']),
                              _linhaBotoes(['4', '5', '6']),
                              _linhaBotoes(['1', '2', '3']),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: _botaoEstilizado('+', operador: true),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: _botaoEstilizado('=', operador: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _botaoEstilizado('0'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _botaoEstilizado('.'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linhaBotoes(
    List<String> botoes, {
    bool operador = false,
    bool memoria = false,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: botoes.map((texto) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: _botaoEstilizado(
                texto,
                operador: operador,
                memoria: memoria,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _botaoEstilizado(
    String texto, {
    bool operador = false,
    bool memoria = false,
  }) {
    final estilo = ElevatedButton.styleFrom(
      backgroundColor: operador
          ? Colors.orange
          : (memoria ? Colors.blueGrey[700] : Colors.grey[300]),
      foregroundColor: operador || memoria ? Colors.white : Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );

    return ElevatedButton(
      style: estilo,
      onPressed: () => _botaoPressionado(texto),
      child: Text(texto),
    );
  }
}
