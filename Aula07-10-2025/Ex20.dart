import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const double alturaRodape = 80.0;
const Color fundo = Color(0xFF1E164B);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const ImcPage(),
    );
  }
}

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});

  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  int altura = 150;
  int peso = 65;

  double get imc => peso / ((altura / 100) * (altura / 100));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IMC')),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.male, color: Colors.white, size: 80.0),
                        SizedBox(height: 15),
                        Text('MASC',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.female, color: Colors.white, size: 80.0),
                        SizedBox(height: 15),
                        Text('FEM',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Altura
          Expanded(
            child: Caixa(
              cor: fundo,
              filho: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Altura:',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('$altura',
                      style:
                          const TextStyle(fontSize: 24, color: Colors.white)),
                  Slider(
                    value: altura.toDouble(),
                    min: 100,
                    max: 220,
                    activeColor: Colors.blue,
                    onChanged: (double valor) {
                      setState(() {
                        altura = valor.round();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Peso e Resultado
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Peso:',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        Text('$peso',
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  peso++;
                                });
                              },
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (peso > 0) peso--;
                                });
                              },
                              child:
                                  const Icon(Icons.remove, color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Caixa(
                    cor: fundo,
                    filho: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Resultado:',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                        Text(imc.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Rodapé
          Container(
            color: const Color(0xFF638ED6),
            width: double.infinity,
            height: alturaRodape,
            margin: const EdgeInsets.only(top: 10.0),
          ),
        ],
      ),
    );
  }
}

class Caixa extends StatelessWidget {
  final Color cor;
  final Widget? filho;

  const Caixa({required this.cor, this.filho, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: cor,
      ),
      child: filho,
    );
  }
}
