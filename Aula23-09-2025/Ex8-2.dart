/* Precisará substituir a seguinte linha do pubspec.yaml:
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.0.15 

Após adicionar essas linhas, execute no terminal do vs code o comando abaixo:
flutter pub get
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PerguntasApp());
}

class PerguntasApp extends StatelessWidget {
  const PerguntasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz de Conhecimentos Gerais',
      home: const PerguntasScreen(),
    );
  }
}

class PerguntasScreen extends StatefulWidget {
  const PerguntasScreen({super.key});

  @override
  State<PerguntasScreen> createState() => _PerguntasScreenState();
}

class _PerguntasScreenState extends State<PerguntasScreen> {
  List<Widget> resultado = [];
  int numeroPergunta = 0;

  List<Map<String, dynamic>> perguntas = [
    {
      'texto': 'Qual é a capital da França?',
      'resposta': 'Paris',
      'correta': true
    },
    {
      'texto': 'Qual é o maior planeta do sistema solar?',
      'resposta': 'Júpiter',
      'correta': true
    },
    {
      'texto': 'Quem escreveu "Dom Quixote"?',
      'resposta': 'Miguel de Cervantes',
      'correta': true
    },
    {
      'texto': 'Qual é a capital do Brasil?',
      'resposta': 'Brasília',
      'correta': true
    },
    {'texto': 'Quantos continentes existem?', 'resposta': '7', 'correta': true},
    {
      'texto': 'Qual é o maior oceano do mundo?',
      'resposta': 'Pacífico',
      'correta': true
    },
    {
      'texto': 'Em que ano o homem chegou à Lua?',
      'resposta': '1969',
      'correta': true
    },
    {
      'texto': 'Quem pintou a Mona Lisa?',
      'resposta': 'Leonardo da Vinci',
      'correta': true
    },
    {'texto': 'Qual é a moeda do Japão?', 'resposta': 'Iene', 'correta': true},
    {
      'texto': 'Quem descobriu a teoria da relatividade?',
      'resposta': 'Albert Einstein',
      'correta': true
    },
    {
      'texto':
          'Você chegou ao final das perguntas, verifique o seu número de acertos no canto inferior da tela',
      'resposta': 'Parabéns por ter chegado até aqui'
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      numeroPergunta = prefs.getInt('numeroPergunta') ?? 0;
    });
  }

  _saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('numeroPergunta', numeroPergunta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz de Conhecimentos Gerais'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  perguntas[numeroPergunta]['texto'],
                  style: const TextStyle(fontFamily: 'Quicksand', fontSize: 32),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'R. ${perguntas[numeroPergunta]['resposta']}',
                style: const TextStyle(fontFamily: 'Quicksand', fontSize: 28),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (numeroPergunta < perguntas.length - 1) {
                    if (perguntas[numeroPergunta]['correta'] == true) {
                      resultado.add(
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      );
                    } else {
                      resultado.add(
                        const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      );
                    }
                    numeroPergunta++;
                    _saveState(); // Salva o estado
                  }
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 60),
              ),
              child: const Text(
                'SIM',
                style: TextStyle(fontFamily: 'Quicksand', fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (numeroPergunta < perguntas.length - 1) {
                        if (perguntas[numeroPergunta]['correta'] == false) {
                          resultado.add(
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          );
                        } else {
                          resultado.add(
                            const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          );
                        }
                        numeroPergunta++;
                        _saveState(); // Salva o estado
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 60),
                  ),
                  child: const Text(
                    'NÃO',
                    style: TextStyle(fontFamily: 'Quicksand', fontSize: 22),
                  )),
            ),
            Row(
              children: resultado,
            )
          ],
        ),
      ),
    );
  }
}
