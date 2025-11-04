import 'package:flutter/material.dart';
import 'calculadorainicio.dart';
import 'bancodados.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BancoDados.instance.database;

  runApp(const Aplicativo());
}

class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora SQLite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const TelaCalculadora(),
    );
  }
}
