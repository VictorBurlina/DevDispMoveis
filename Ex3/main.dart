import 'dart:convert';
import 'dart:math';
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
      home: const TrunfoPokemonPage(),
    );
  }
}

class TrunfoPokemonPage extends StatefulWidget {
  const TrunfoPokemonPage({super.key});

  @override
  State<TrunfoPokemonPage> createState() => _TrunfoPokemonPageState();
}

class _TrunfoPokemonPageState extends State<TrunfoPokemonPage> {
  final Random random = Random();

  Map? playerCard;
  Map? cpuCard;

  String chosenAttribute = "";
  String result = "";

  int playerScore = 0;
  int cpuScore = 0;

  // Atributos da API para comparar
  final atributos = [
    "hp",
    "attack",
    "defense",
    "speed",
    "special-attack",
    "special-defense",
  ];

  Future<Map?> getPokemon() async {
    int id = random.nextInt(151) + 1;

    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon/$id");
    final response = await http.get(url);

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);

    Map<String, int> stats = {};
    for (var s in data["stats"]) {
      stats[s["stat"]["name"]] = s["base_stat"];
    }

    return {
      "nome": data["name"],
      "img": data["sprites"]["front_default"],
      "stats": stats,
    };
  }

  Future<void> jogar() async {
    setState(() {
      result = "";
      chosenAttribute = "";
    });

    final p1 = await getPokemon();
    final p2 = await getPokemon();

    if (p1 == null || p2 == null) {
      setState(() => result = "Erro ao carregar pokémons.");
      return;
    }

    playerCard = p1;
    cpuCard = p2;

    chosenAttribute = atributos[random.nextInt(atributos.length)];

    int valPlayer = playerCard!["stats"][chosenAttribute];
    int valCPU = cpuCard!["stats"][chosenAttribute];

    setState(() {
      if (valPlayer > valCPU) {
        playerScore++;
        result = "Você venceu!";
      } else if (valCPU > valPlayer) {
        cpuScore++;
        result = "CPU venceu!";
      } else {
        result = "Empate!";
      }
    });
  }

  Widget carta(String titulo, Map? p) {
    if (p == null) return const Text("Sem carta");

    return Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (p["img"] != null) Image.network(p["img"], height: 100),
        const SizedBox(height: 5),
        Text(
          p["nome"].toString().toUpperCase(),
          style: const TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 10),
        Text("HP: ${p["stats"]["hp"]}"),
        Text("Ataque: ${p["stats"]["attack"]}"),
        Text("Defesa: ${p["stats"]["defense"]}"),
        Text("Velocidade: ${p["stats"]["speed"]}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Super Trunfo – Pokémon")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Placar – Você $playerScore x $cpuScore CPU",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: Row(
                children: [
                  Expanded(child: carta("CPU", cpuCard)),
                  Expanded(child: carta("Você", playerCard)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (chosenAttribute.isNotEmpty)
              Text(
                "Atributo escolhido: $chosenAttribute",
                style: const TextStyle(fontSize: 18),
              ),

            const SizedBox(height: 10),

            Text(result, style: const TextStyle(fontSize: 24)),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: jogar, child: const Text("Jogar")),
          ],
        ),
      ),
    );
  }
}
