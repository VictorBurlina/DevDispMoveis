import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PrimeiraPagina(),
    ),
  );
}

class PrimeiraPagina extends StatelessWidget {
  const PrimeiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        title: Text('Meu Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: Image.network('https://static.vecteezy.com/system/resources/previews/009/267/561/non_2x/user-icon-design-free-png.png',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Victor Burlina',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('Idade: 20 anos', style: TextStyle(fontSize: 18)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SegundaPagina()),
                );
              },
              child: Text('Filmes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TerceiraPagina()),
                );
              },
              child: Text('Livros'),
            ),
          ],
        ),
      ),
    );
  }
}

class SegundaPagina extends StatelessWidget {
  const SegundaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text('Filmes Favoritos'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text('1. Velozes e Furiosos 7'),
          Text('2. Matrix'),
          Text('3. Vingadores: Ultimato'),
          Text('4. Gente Grande'),
          Text('5. Adão Negro'),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Voltar'),
          ),
        ],
      ),
    );
  }
}

class TerceiraPagina extends StatelessWidget {
  const TerceiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text('Livros Favoritos'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text('1. Magic Emperor'),
          Text('2. NanoMachine'),
          Text('3. O Retorno do Cão de Caça'),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
