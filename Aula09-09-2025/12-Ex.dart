import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const PedraPapelTesoura());
}

class PedraPapelTesoura extends StatefulWidget {
  const PedraPapelTesoura({super.key});

  @override
  State<PedraPapelTesoura> createState() => _PedraPapelTesouraState();
}

class _PedraPapelTesouraState extends State<PedraPapelTesoura> {
  final opcoes = ['Pedra', 'Papel', 'Tesoura'];
  String? escolhaUsuario;
  String? escolhaMaquina;
  String resultado = '';
  int jogadas = 0;

  final random = Random();
  final AudioPlayer player = AudioPlayer();

  void tocarSom(String arquivo) async {
    await player.stop();
    await player.play(DeviceFileSource('imagens/$arquivo'));
  }

  void jogar(String escolha) {
    setState(() {
      escolhaUsuario = escolha;
      jogadas++;

      int idxUsuario = opcoes.indexOf(escolhaUsuario!);
      int idxMaquina;

      if (jogadas % 5 == 0) {
        idxMaquina = (idxUsuario + 2) % 3;
        resultado = 'Você ganhou!';
        tocarSom('vitoria.mp3');
      } else {
        int sorteio = random.nextInt(2);
        if (sorteio == 0) {
          idxMaquina = (idxUsuario + 1) % 3;
          resultado = 'A máquina ganhou!';
          tocarSom('derrota.mp3');
        } else {
          idxMaquina = idxUsuario;
          resultado = 'Empate!';
          tocarSom('empate.mp3');
        }
      }

      escolhaMaquina = opcoes[idxMaquina];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Jogo: Pedra, Papel ou Tesoura')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Escolha uma opção:'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: opcoes.map((opcao) {
                  return ElevatedButton(
                    onPressed: () => jogar(opcao),
                    child: Text(opcao),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (escolhaUsuario != null && escolhaMaquina != null) ...[
                Text('Você escolheu: $escolhaUsuario'),
                Text('Máquina escolheu: $escolhaMaquina'),
                const SizedBox(height: 10),
                Text(
                  resultado,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: resultado == 'Você ganhou!'
                        ? Colors.green
                        : resultado == 'A máquina ganhou!'
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Jogadas: $jogadas'),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
