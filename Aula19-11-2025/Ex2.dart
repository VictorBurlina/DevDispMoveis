import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DictionaryPage(),
    );
  }
}

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  TextEditingController controlador = TextEditingController();
  String? definition;
  String? erro;
  bool carregando = false;

  Future<void> buscarDefinicao(String palavra) async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final url = "https://api.dictionaryapi.dev/api/v2/entries/en/$palavra";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        setState(() {
          erro = "Erro ao buscar definição.";
          carregando = false;
        });
        return;
      }

      final data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty) {
        setState(() {
          definition = data[0]['meanings'][0]['definitions'][0]['definition'];
          carregando = false;
        });
      } else {
        setState(() {
          erro = "Definição não encontrada.";
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = "Erro inesperado: $e";
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dicionário de Inglês")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controlador,
              decoration: const InputDecoration(
                hintText: "Digite uma palavra em inglês",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                buscarDefinicao(controlador.text);
              },
              child: const Text("Buscar Definição"),
            ),
            const SizedBox(height: 30),
            if (carregando) const CircularProgressIndicator(),
            if (erro != null)
              Text(
                erro!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            if (definition != null)
              Text(
                "Definição: $definition",
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
    );
  }
}
