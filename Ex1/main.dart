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
      home: const ClimaPage(),
    );
  }
}

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  TextEditingController controlador = TextEditingController();

  String? temperatura;
  String? umidade;
  String? vento;
  String? erro;

  bool carregando = false;

  Future<void> buscarClima(String cidade) async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      // 1) Encode do nome da cidade
      final cidadeEncoded = Uri.encodeQueryComponent(cidade.trim());

      final geoUrl =
          "https://geocoding-api.open-meteo.com/v1/search?name=$cidadeEncoded&count=1&language=pt&format=json";

      final geoResponse = await http.get(Uri.parse(geoUrl));

      print("STATUS GEOCODING: ${geoResponse.statusCode}");
      print("BODY GEOCODING: ${geoResponse.body}");

      if (geoResponse.statusCode != 200) {
        setState(() {
          erro = "Erro ao buscar localização.";
          carregando = false;
        });
        return;
      }

      final geoData = jsonDecode(geoResponse.body);

      if (!geoData.containsKey("results") ||
          geoData["results"] == null ||
          (geoData["results"] as List).isEmpty) {
        setState(() {
          erro = "Cidade não encontrada.";
          carregando = false;
        });
        return;
      }

      final lat = geoData["results"][0]["latitude"];
      final lon = geoData["results"][0]["longitude"];

      print("LAT: $lat  LON: $lon");

      final climaUrl =
          "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,wind_speed_10m";

      final climaResponse = await http.get(Uri.parse(climaUrl));

      print("STATUS CLIMA: ${climaResponse.statusCode}");
      print("BODY CLIMA: ${climaResponse.body}");

      if (climaResponse.statusCode != 200) {
        setState(() {
          erro = "Erro ao buscar clima.";
          carregando = false;
        });
        return;
      }

      final climaData = jsonDecode(climaResponse.body);
      final current = climaData["current"];

      setState(() {
        temperatura = "${current['temperature_2m']} °C";
        umidade = "${current['relative_humidity_2m']} %";
        vento = "${current['wind_speed_10m']} km/h";
        carregando = false;
      });
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
      appBar: AppBar(title: const Text("Clima – Open Meteo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controlador,
              decoration: const InputDecoration(
                hintText: "Digite uma cidade",
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                buscarClima(controlador.text);
              },
              child: const Text("Buscar clima"),
            ),

            const SizedBox(height: 30),

            if (carregando) const CircularProgressIndicator(),

            if (erro != null)
              Text(
                erro!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),

            if (!carregando && erro == null && temperatura != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Temperatura: $temperatura",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Umidade: $umidade",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Velocidade do vento: $vento",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
