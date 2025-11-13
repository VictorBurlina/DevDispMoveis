import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Classe Localizacao
class Localizacao {
  double? latitude;
  double? longitude;

  // Método que pega a localização atual
  Future<void> pegaLocalizacaoAtual() async {
    try {
      // Solicitar permissão
      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }
      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        print('Permissão negada');
        return;
      }

      // Obter a posição atual
      Position posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Ajusta latitude e longitude
      latitude = posicao.latitude;
      longitude = posicao.longitude;
    } catch (e) {
      print('Erro ao obter localização: $e');
    }
  }
}

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Localizacao localizacao = Localizacao();

  @override
  void initState() {
    super.initState();
    // Pega a localização assim que o app iniciar
    localizacao.pegaLocalizacaoAtual().then((_) {
      setState(() {}); // Atualiza a tela após obter a localização
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Busca Local')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Busca Local'),
              // Exibe a latitude e longitude
              Text('Latitude: ${localizacao.latitude ?? "?"}'),
              Text('Longitude: ${localizacao.longitude ?? "?"}'),
            ],
          ),
        ),
      ),
    );
  }
}
