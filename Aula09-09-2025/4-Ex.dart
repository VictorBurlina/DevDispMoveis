import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const PedraPapelTesouraApp());
}

class PedraPapelTesouraApp extends StatefulWidget {
  const PedraPapelTesouraApp({super.key});

  @override
  State<PedraPapelTesouraApp> createState() => _PedraPapelTesouraAppState();
}

class _PedraPapelTesouraAppState extends State<PedraPapelTesouraApp> {
  var imagens = [
    'https://t3.ftcdn.net/jpg/01/23/14/80/360_F_123148069_wkgBuIsIROXbyLVWq7YNhJWPcxlamPeZ.jpg', // Pedra
    'https://i.ebayimg.com/00/s/MTIwMFgxNjAw/z/KAcAAOSwTw5bnTbW/\$_57.JPG', // Papel
    'https://t4.ftcdn.net/jpg/02/55/26/63/360_F_255266320_plc5wjJmfpqqKLh0WnJyLmjc6jFE9vfo.jpg', // Tesoura
  ];

  int indiceAtual = 0;

  void escolherAleatorio() {
    setState(() {
      var novoIndice;
      do {
        novoIndice = Random().nextInt(imagens.length);
      } while (novoIndice == indiceAtual);
      indiceAtual = novoIndice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Pedra, Papel ou Tesoura')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Encolhe os elementos se precisar
              mainAxisSize: MainAxisSize.min,
              children: [
                // Limitando o tamanho da imagem
                SizedBox(
                  height: 300,
                  child: Image.network(
                    imagens[indiceAtual],
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: escolherAleatorio,
                  child: const Text('Escolher'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
