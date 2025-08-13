import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: PrimeiraPagina()),
  );
}

class PrimeiraPagina extends StatelessWidget {
  const PrimeiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Página A'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Coruja Buraqueira'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'A coruja-buraqueira é uma ave strigiforme da família Strigidae. Também conhecida pelos nomes de caburé, caburé-de-cupim, caburé-do-campo, coruja-barata, coruja-do-campo, coruja-mineira, corujinha-buraqueira, corujinha-do-buraco, corujinha-do-campo, guedé, urucuera, urucureia, urucuriá, coruja-cupinzeira (algumas cidades de Goiás) e capotinha. Com o nome científico cunicularia (“pequeno mineiro”), recebe esse nome por cavar buracos no solo. Vive cerca de 9 anos em habitat selvagem. Costuma viver em campos, pastos, restingas, desertos, planícies, praias e aeroportos.',
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              width: 200,
              color: Colors.lightBlue,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              child: Image.network(
                'https://agron.com.br/wp-content/uploads/2025/05/Como-a-coruja-buraqueira-vive-em-grupo-2.webp',
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SegundaPagina(),
                  ),
                );
              },
              child: const Text('Ir para página da Rolinha-do-planalto'),
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
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text('Página B'),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Rolinha-do-planalto'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Assunto(s): Ave. Sexo: Indeterminado. Idade: Adulto. Autor: Victor Burlina - ALUNO DO MAURAO. Local de Observação: Município: Botumirim/MG. Feita em: 13/07/2015. Publicada em: 25/05/2016. Câmera: Canon EOS 7D. Observações do autor: Atendendo a pedidos, segue a foto da nossa rolinha-do-planalto. Espécie desaparecida desde 1941 quando foi registrada por Walter Garbe no sul de Goiás. Essa imagem não foi realizada na cidade de Belo Horizonte, mas sim no interior de Minas Gerais. Tão logo possamos divulgar à localidade, a região será alterada. Informações técnicas: Fabricante: Canon, Câmera: Canon EOS 7D, Tempo de Exposição: 1/80, Abertura: F/7.1, Velocidade ISO: 800, Data e hora: 2015:07:13 08:45:50, Flash: Off, Distância Focal: 300.0 mm, Modo de exposição: Auto, Equilíbrio de Branco: Auto, Tipo de Captura de Cena: Standard.',
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              width: 200,
              color: Colors.lightBlue,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              child: Image.network(
                'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSIX6kvUSWf_BvsXidpBUceCnKJ0I1ln3fZ3Vg5r0i5t1BMamvtdth1OBLWVBb27dl7wnvy9ywVv_75cMsUxBIbOBPRaR3esr7eXaB08ilY0g',
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Voltar para a página da Coruja'),
            ),
          ],
        ),
      ),
    );
  }
}
