import 'package:flutter/material.dart';
import 'dart:math';

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

  void jogar(String escolha) {
    setState(() {
      escolhaUsuario = escolha;
      jogadas++;

      // Determina o índice da escolha do usuário
      int idxUsuario = opcoes.indexOf(escolhaUsuario!);
      int idxMaquina;

      // Manipular resultado: 1 vitória a cada 5 jogadas
      if (jogadas % 5 == 0) {
        // Vitória do usuário
        idxMaquina = (idxUsuario + 2) %
            3; // Ex: Usuário = Pedra (0), Maquina = Tesoura (2)
        resultado = 'Você ganhou!';
      } else {
        // Derrota ou empate aleatório
        int sorteio = random.nextInt(2); // 0 ou 1
        if (sorteio == 0) {
          // Derrota
          idxMaquina = (idxUsuario + 1) % 3; // Pedra perde pra Papel, etc.
          resultado = 'A máquina ganhou!';
        } else {
          // Empate
          idxMaquina = idxUsuario;
          resultado = 'Empate!';
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
