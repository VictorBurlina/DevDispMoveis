import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'bancodados.dart';

class TelaHistorico extends StatefulWidget {
  const TelaHistorico({super.key});

  @override
  State<TelaHistorico> createState() => _TelaHistoricoEstado();
}

class _TelaHistoricoEstado extends State<TelaHistorico> {
  late Future<List<Map<String, dynamic>>> _futuroOperacoes;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  void _carregarHistorico() {
    _futuroOperacoes = BancoDados.instance.obterOperacoes();
  }

  String _formatarData(String dataIso) {
    try {
      final data = DateTime.parse(dataIso);
      return DateFormat('dd/MM/yyyy HH:mm').format(data);
    } catch (e) {
      return dataIso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Operações')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futuroOperacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma operação registrada.'));
          }

          final operacoes = snapshot.data!;

          return ListView.builder(
            itemCount: operacoes.length,
            itemBuilder: (context, index) {
              final op = operacoes[index];
              return ListTile(
                title: Text(
                  op['descricaoOperacao'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_formatarData(op['dataHora'])),
              );
            },
          );
        },
      ),
    );
  }
}
