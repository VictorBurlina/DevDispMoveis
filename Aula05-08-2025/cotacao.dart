import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Hello, World!'))),
    );
  }
}

// Formatando data no formato correto
String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}

// Função assíncrona para buscar um post na API
Future<void> buscaPost() async {
  // Pegar a data anterior do dia (ontem)
  DateTime ontem = DateTime.now().subtract(Duration(days: 1));

  // Se ontem for um domingo, irá voltar para sexta-feira
  if (ontem.weekday == DateTime.sunday) {
    ontem = ontem.subtract(Duration(days: 2));
  }

  // Formata a data no formato necessário para a API
  String dataBase = formatDate(ontem);

  // URL da API que será acessada
  var url = Uri.https('olinda.bcb.gov.br',
    '/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarDia(dataCotacao=@dataCotacao)',
    {
      '@dataCotacao': '\'${dataBase}\'',
      '\$top': '100',
      '\$format': 'json',
      '\$select': 'cotacaoCompra'
    }
  );

  try {
    // 2. Faz a requisição GET e espera a resposta
    var response = await http.get(url);

    // 3. Verifica se a requisição foi bem-sucedida
    if (response.statusCode == 200) {
      // 4. Decodifica o JSON da resposta
      var jsonBody = json.decode(response.body);

      // 5. Extrai e imprime o valor que queremos
      var cotacao = jsonBody['value'][0]['cotacaoCompra'];
      print('Cotação do dólar no dia $dataBase: $cotacao');
    } else {
      print('Erro ao acessar a API. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    // 6. Trata possíveis erros de conexão
    print('Ocorreu um erro na requisição: $e');
  }
}

void main() {
  buscaPost();
}
