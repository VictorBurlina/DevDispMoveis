import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RaioTabScreen(),
    );
  }
}

class RaioTabScreen extends StatefulWidget {
  @override
  _RaioTabScreenState createState() => _RaioTabScreenState();
}

class _RaioTabScreenState extends State<RaioTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _controlador = TextEditingController();
  double raio = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculos do Círculo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Raio'),
            Tab(text: 'Diâmetro'),
            Tab(text: 'Circunferência'),
            Tab(text: 'Área'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRaioTab(),
          _buildDiametroTab(),
          _buildCircunferenciaTab(),
          _buildAreaTab(),
        ],
      ),
    );
  }

  Widget _buildRaioTab() {
    return Padding(
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
              setState(() {
                raio = double.parse(_controlador.text);
              });
            },
            child: Text('Confirmar Raio'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiametroTab() {
    return Center(
      child: Text('Diâmetro: ${2 * raio}'),
    );
  }

  Widget _buildCircunferenciaTab() {
    return Center(
      child: Text('Circunferência: ${2 * pi * raio}'),
    );
  }

  Widget _buildAreaTab() {
    return Center(
      child: Text('Área: ${pi * raio * raio}'),
    );
  }
}
