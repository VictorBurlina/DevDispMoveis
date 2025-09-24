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
  runApp(const TabuadaApp());
}

class TabuadaApp extends StatelessWidget {
  const TabuadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabuada',
      home: const TabuadaScreen(),
    );
  }
}

class TabuadaScreen extends StatefulWidget {
  const TabuadaScreen({super.key});

  @override
  State<TabuadaScreen> createState() => _TabuadaScreenState();
}

class _TabuadaScreenState extends State<TabuadaScreen> {
  final TextEditingController _controller = TextEditingController();
  int numero = 1;
  int contagem = 1;
  int respostaCorreta = 0;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  // Carregar o estado salvo (numero e contagem)
  _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      numero = prefs.getInt('numero') ?? 1;
      contagem = prefs.getInt('contagem') ?? 1;
      respostaCorreta = prefs.getInt('respostaCorreta') ?? 0;
    });
  }

  // Salvar o estado atual (numero, contagem e respostaCorreta)
  _saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('numero', numero);
    prefs.setInt('contagem', contagem);
    prefs.setInt('respostaCorreta', respostaCorreta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treine a Tabuada'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quanto é $numero x $contagem?',
              style: const TextStyle(fontSize: 28),
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sua Resposta'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  int resposta = int.tryParse(_controller.text) ?? 0;
                  if (resposta == numero * contagem) {
                    respostaCorreta++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resposta Correta!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resposta Errada!')),
                    );
                  }

                  if (contagem < 10) {
                    contagem++;
                  } else {
                    contagem = 1;
                    numero++;
                    if (numero > 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Você acertou $respostaCorreta perguntas!')),
                      );
                      numero = 1; // Reseta a tabuada quando chega no 10
                      respostaCorreta =
                          0; // Reseta a contagem de respostas corretas
                    }
                  }

                  _saveState(); // Salva o estado a cada interação
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Verificar', style: TextStyle(fontSize: 22)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Respostas corretas: $respostaCorreta',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
