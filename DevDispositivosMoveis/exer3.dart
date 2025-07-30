void main() {
  // Ex: 3 - Usando for e DateTime crie um programa em Dart que mostra o calendário do mês atual, mostrando 7 dias em cada linha e indo até o dia de hoje apenas. A primeira linha deve ser: | D | S | T | Q | Q | S | S |

  final now = DateTime.now();

  int ano = now.year;
  int mes = now.month;
  DateTime primeiroDia = DateTime(ano, mes, 1);
  DateTime hoje = DateTime(ano, mes, now.day);
  int diaSemana = primeiroDia.weekday % 7;
  

  print('| D | S | T | Q | Q | S | S |');
  
  String linha = '';
  for (int i = 0; i < diaSemana; i++) {
    linha += '|   ';
  }

  for (DateTime dia = primeiroDia;
      !dia.isAfter(hoje);
      dia = dia.add(Duration(days: 1))) {
    String diaStr = dia.day.toString().padLeft(2, ' ');
    linha += '|${diaStr} ';

    if (dia.weekday % 7 == 6) {
      linha += '|';
      print(linha);
      linha = '';
    }
  }

  if (linha.isNotEmpty) {
    linha += '|';
    print(linha);
  }
}