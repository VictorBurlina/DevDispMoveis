import 'package:flutter/material.dart';

void main() {
  runApp(const PetApp());
}

enum Pet { gato, cachorro }

class PetApp extends StatefulWidget {
  const PetApp({super.key});

  @override
  State<PetApp> createState() => _PetAppState();
}

class _PetAppState extends State<PetApp> {
  Pet petSelecionado = Pet.cachorro;
  int idadeReal = 1;
  double peso = 10.0;
  double idadeHumana = 0.0;

  // ---- Tabela de gatos (anos reais -> anos humanos)
  final Map<int, int> tabelaGatos = {
    1: 15,
    2: 24,
    3: 28,
    4: 32,
    5: 36,
    6: 40,
    7: 44,
    8: 48,
    9: 52,
    10: 56,
    11: 60,
    12: 64,
    13: 68,
    14: 72,
    15: 76,
    16: 80,
    17: 84,
    18: 88,
    19: 92,
    20: 96,
    21: 100
  };

  // ---- Tabela de cachorros (anos reais -> anos humanos por faixa de peso)
  final Map<int, List<int>> tabelaCachorros = {
    1: [15, 15, 15, 15],
    2: [24, 24, 24, 24],
    3: [28, 28, 30, 32],
    4: [32, 33, 35, 37],
    5: [36, 37, 40, 42],
    6: [40, 42, 45, 49],
    7: [44, 47, 50, 56],
    8: [48, 51, 55, 64],
    9: [52, 56, 61, 71],
    10: [56, 60, 66, 78],
    11: [60, 65, 72, 86],
    12: [64, 69, 77, 93],
    13: [68, 74, 82, 101],
    14: [72, 78, 88, 108],
    15: [76, 83, 93, 115],
    16: [80, 87, 99, 123],
    17: [84, 92, 104, 0],
    18: [88, 96, 109, 0],
    19: [92, 101, 115, 0],
  };

  void calcularIdade() {
    double resultado = 0;

    if (petSelecionado == Pet.gato) {
      resultado = (tabelaGatos[idadeReal]?.toDouble()) ??
          tabelaGatos.values.last.toDouble();
    } else {
      // Determina faixa de peso
      int faixa = 0;
      if (peso <= 9.07)
        faixa = 0;
      else if (peso <= 22.7)
        faixa = 1;
      else if (peso <= 40.8)
        faixa = 2;
      else
        faixa = 3;

      // Busca valor correspondente
      List<int>? valores = tabelaCachorros[idadeReal];
      if (valores != null && faixa < valores.length) {
        resultado = valores[faixa].toDouble();
      } else {
        resultado = tabelaCachorros.values.last[faixa].toDouble();
      }
    }

    setState(() {
      idadeHumana = resultado;
    });
  }

  @override
  void initState() {
    super.initState();
    calcularIdade();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Idade Fisiológica do Pet")),
        body: Column(
          children: [
            // Seleção Gato/Cachorro
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          petSelecionado = Pet.cachorro;
                          calcularIdade();
                        });
                      },
                      child: Caixa(
                        cor: petSelecionado == Pet.cachorro
                            ? Colors.blueAccent
                            : const Color(0xFF1E164B),
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 80, color: Colors.white),
                            SizedBox(height: 10),
                            Text("CACHORRO",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          petSelecionado = Pet.gato;
                          calcularIdade();
                        });
                      },
                      child: Caixa(
                        cor: petSelecionado == Pet.gato
                            ? Colors.purple
                            : const Color(0xFF1E164B),
                        filho: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets_outlined,
                                size: 80, color: Colors.white),
                            SizedBox(height: 10),
                            Text("GATO", style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Peso
            Expanded(
              child: Caixa(
                cor: const Color(0xFF1E164B),
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Peso (kg):",
                        style: TextStyle(color: Colors.grey)),
                    Text(peso.toStringAsFixed(1),
                        style:
                            const TextStyle(fontSize: 22, color: Colors.white)),
                    Slider(
                      min: 1,
                      max: 60,
                      divisions: 59,
                      value: peso,
                      onChanged: (novoPeso) {
                        setState(() {
                          peso = novoPeso;
                          calcularIdade();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Idade real
            Expanded(
              child: Caixa(
                cor: const Color(0xFF1E164B),
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Idade real (anos):",
                        style: TextStyle(color: Colors.grey)),
                    Text("$idadeReal",
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (idadeReal > 1) idadeReal--;
                              calcularIdade();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey),
                          child: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (idadeReal < 21) idadeReal++;
                              calcularIdade();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Resultado
            Expanded(
              child: Caixa(
                cor: const Color(0xFF1E164B),
                filho: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Idade fisiológica (anos humanos):",
                        style: TextStyle(color: Colors.grey)),
                    Text("${idadeHumana.toStringAsFixed(1)} anos",
                        style:
                            const TextStyle(fontSize: 28, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget filho;

  const Caixa({super.key, required this.cor, required this.filho});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(color: cor, borderRadius: BorderRadius.circular(12)),
      child: filho,
    );
  }
}
