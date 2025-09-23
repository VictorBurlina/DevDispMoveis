import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RaioInput(),
    );
  }
}

class RaioInput extends StatefulWidget {
  @override
  _RaioInputState createState() => _RaioInputState();
}

class _RaioInputState extends State<RaioInput> {
  final TextEditingController _controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digite o Raio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controlador,
              decoration: InputDecoration(labelText: 'Raio do Círculo'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double raio = double.parse(_controlador.text);
                double area = pi * raio * raio;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AreaScreen(area: area),
                  ),
                );
              },
              child: Text('Calcular Área'),
            ),
          ],
        ),
      ),
    );
  }
}

class AreaScreen extends StatelessWidget {
  final double area;

  AreaScreen({required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Área do Círculo')),
      body: Center(
        child: Text('A área do círculo é: ${area.toStringAsFixed(2)}'),
      ),
    );
  }
}
