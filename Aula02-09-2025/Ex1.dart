import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  String operador1 = '';
  String operador2 = '';
  bool somaApertado = false;
  int resultado = 0;
  bool resultadoMostrado = false;

  void adicionarDigito(String digito) {
    if (resultadoMostrado) {
      operador1 = '';
      operador2 = '';
      somaApertado = false;
      resultadoMostrado = false;
    }

    if (!somaApertado) {
      operador1 += digito;
    } else {
      operador2 += digito;
    }

    print('Operador 1: $operador1');
    print('Operador 2: $operador2');
    print('Soma apertado: $somaApertado');
  }

  void realizarSoma() {
    if (operador1.isNotEmpty && operador2.isNotEmpty) {
      resultado = int.parse(operador1) + int.parse(operador2);
      print('Resultado: $resultado');

      resultadoMostrado = true;
    }
  }

  void apertarSoma() {
    somaApertado = true;
    print('Soma apertado: $somaApertado');
  }

  Widget criarBotao(String texto, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(texto),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Calculadora Flutter"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
        ),
      ),
    );
  }
}
