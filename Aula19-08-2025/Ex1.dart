import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashcardApp(),
    ),
  );
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  // 🔧 Função para criar um card de verbo
  Widget flashcard({
    required String tempo,
    required String frase,
    required String imagemUrl,
    required IconData icone,
    required Color corFundo,
  }) {
    return Column(
      children: [
        Card(
          color: corFundo,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Icon(
                  icone,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  tempo,
                  style: GoogleFonts.rampartOne(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  frase,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
              ),
              Image.network(
                imagemUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    print('Memorizado: $frase');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: corFundo,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: Text('Memorizado'),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey.shade600,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Flashcards - Verbos em Inglês'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          flashcard(
            tempo: 'Passado',
            frase: 'She **walked** to school yesterday.',
            imagemUrl: 'https://i.imgur.com/FzafBzN.png',
            icone: Icons.history,
            corFundo: Colors.deepOrange,
          ),
          flashcard(
            tempo: 'Presente',
            frase: 'He **plays** football every weekend.',
            imagemUrl: 'https://i.imgur.com/jT9wW9B.png',
            icone: Icons.wb_sunny,
            corFundo: Colors.green,
          ),
          flashcard(
            tempo: 'Futuro',
            frase: 'They **will travel** to Japan next year.',
            imagemUrl: 'https://i.imgur.com/ErFGrhR.png',
            icone: Icons.event,
            corFundo: Colors.purple,
          ),
        ],
      ),
    );
  }
}
