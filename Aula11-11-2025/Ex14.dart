import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double? temperatura;
  double? umidade;
  double? vento;
  String mensagem = 'Buscando dados...';

  @override
  void initState() {
    super.initState();
    buscaDadosClima();
  }

  Future<void> buscaDadosClima() async {
    try {
      // 1️⃣ Pede permissão de localização
      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }
      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        setState(() {
          mensagem = 'Permissão de localização negada.';
        });
        return;
      }

      // 2️⃣ Pega posição atual
      Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = posicao.latitude;
      double lon = posicao.longitude;

      // 3️⃣ Faz requisição à API do Open-Meteo
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true&temperature_unit=celsius&windspeed_unit=kmh&precipitation_unit=mm',
      );

      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        var dados = json.decode(resposta.body);

        setState(() {
          temperatura = dados['current_weather']['temperature'];
          umidade = dados['current_weather']['humidity'];
          vento = dados['current_weather']['windspeed'];
          mensagem = 'Dados carregados com sucesso!';
        });
      } else {
        setState(() {
          mensagem = 'Erro ao buscar dados (${resposta.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        mensagem = 'Erro: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Clima Atual')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mensagem, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              if (temperatura != null)
                Column(
                  children: [
                    Text(
                      '🌡️ Temperatura: ${temperatura!.toStringAsFixed(1)} °C',
                    ),
                    Text(
                      '💧 Umidade: ${umidade?.toStringAsFixed(0) ?? 'N/A'} %',
                    ),
                    Text(
                      '🌬️ Vento: ${vento?.toStringAsFixed(1) ?? 'N/A'} km/h',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
