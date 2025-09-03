import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String operador1 = '';
  String operador2 = '';
  bool somaApertado = false;
  String visor = '0';
  bool resultadoMostrado = false;

  void adicionarDigito(String digito) {
    setState(() {
      if (resultadoMostrado) {
        operador1 = '';
        operador2 = '';
        somaApertado = false;
        visor = '0';
        resultadoMostrado = false;
      }

      if (!somaApertado) {
        operador1 += digito;
        visor = operador1;
      } else {
        operador2 += digito;
        visor = operador2;
      }
    });
  }

  void apertarSoma() {
    setState(() {
      somaApertado = true;
    });
  }

  void realizarSoma() {
    setState(() {
      if (operador1.isNotEmpty && operador2.isNotEmpty) {
        int resultado = int.parse(operador1) + int.parse(operador2);
        visor = resultado.toString();

        resultadoMostrado = true;
      }
    });
  }

  Widget criarBotao(String texto, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(texto, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora Flutter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // aq foi acrescentado um visor para aparecer os números
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            alignment: Alignment.centerRight,
            child: Text(
              visor,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          // aq dentro sera criado os botões com os números
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              criarBotao('7', () => adicionarDigito('7')),
              criarBotao('8', () => adicionarDigito('8')),
              criarBotao('9', () => adicionarDigito('9')),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              criarBotao('4', () => adicionarDigito('4')),
              criarBotao('5', () => adicionarDigito('5')),
              criarBotao('6', () => adicionarDigito('6')),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              criarBotao('1', () => adicionarDigito('1')),
              criarBotao('2', () => adicionarDigito('2')),
              criarBotao('3', () => adicionarDigito('3')),
            ],
          ),
          // aq irá mostrar na ultima linha os operadores
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              criarBotao('0', () => adicionarDigito('0')),
              criarBotao('=', realizarSoma),
              criarBotao('+', apertarSoma),
            ],
          ),
        ],
      ),
    );
  }
}
