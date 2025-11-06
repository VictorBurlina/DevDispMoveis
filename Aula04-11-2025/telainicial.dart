import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar datas
import 'bancodedados.dart';
import 'tarefa.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Tarefa> _tarefas = [];
  DateTime? _filtroData; // Armazena a data selecionada para filtro

  @override
  void initState() {
    super.initState();
    _refreshTarefas();
  }

  // Carrega as tarefas do banco de dados
  Future<void> _refreshTarefas() async {
    List<Tarefa> lista;
    if (_filtroData == null) {
      lista = await _dbHelper.getAllTarefas();
    } else {
      String dataFormatada = DateFormat('yyyy-MM-dd').format(_filtroData!);
      lista = await _dbHelper.getTarefasByDate(dataFormatada);
    }

    setState(() {
      _tarefas = lista;
    });
  }

  // Mostra o DatePicker para filtrar
  Future<void> _selecionarDataFiltro() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _filtroData ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (dataSelecionada != null) {
      setState(() {
        _filtroData = dataSelecionada;
      });
      _refreshTarefas();
    }
  }

  // Limpa o filtro de data
  void _limparFiltro() {
    setState(() {
      _filtroData = null;
    });
    _refreshTarefas();
  }

  // Mostra o diálogo para Criar ou Editar uma tarefa
  void _showFormDialog([Tarefa? tarefa]) {
    final _formKey = GlobalKey<FormState>();
    String _title = tarefa?.title ?? '';
    DateTime _date = tarefa != null
        ? DateTime.parse(tarefa.date)
        : DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(tarefa == null ? 'Nova Tarefa' : 'Editar Tarefa'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um título';
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value!,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Data: ${DateFormat('dd/MM/yyyy').format(_date)}'),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final DateTime? dataSelecionada =
                                await showDatePicker(
                                  context: context,
                                  initialDate: _date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                            if (dataSelecionada != null) {
                              setDialogState(() {
                                _date = dataSelecionada;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String dataFormatada = DateFormat(
                        'yyyy-MM-dd',
                      ).format(_date);

                      if (tarefa == null) {
                        await _dbHelper.createTarefa(
                          Tarefa(title: _title, date: dataFormatada),
                        );
                      } else {
                        tarefa.title = _title;
                        tarefa.date = dataFormatada;
                        await _dbHelper.updateTarefa(tarefa);
                      }
                      _refreshTarefas();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Diálogo de confirmação para deletar
  void _confirmDelete(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir a tarefa "${tarefa.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _dbHelper.deleteTarefa(tarefa.id!);
                _refreshTarefas();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          if (_filtroData != null)
            IconButton(
              icon: const Icon(Icons.clear_all_rounded),
              tooltip: 'Mostrar Todas',
              onPressed: _limparFiltro,
            ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Filtrar por data',
            onPressed: _selecionarDataFiltro,
          ),
        ],
      ),
      body: _tarefas.isEmpty
          ? Center(
              child: Text(
                _filtroData == null
                    ? 'Nenhuma tarefa cadastrada.'
                    : 'Nenhuma tarefa para ${DateFormat('dd/MM/yyyy').format(_filtroData!)}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];
                  return _TarefaCardItem(
                    tarefa: tarefa,
                    onToggleDone: (bool? value) async {
                      tarefa.isDone = value ?? false;
                      await _dbHelper.updateTarefa(tarefa);
                      _refreshTarefas();
                    },
                    onEdit: () => _showFormDialog(tarefa),
                    onDelete: () => _confirmDelete(tarefa),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        tooltip: 'Nova Tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---------------------------------
// WIDGET CUSTOMIZADO PARA O ITEM DA LISTA
// ---------------------------------
class _TarefaCardItem extends StatelessWidget {
  final Tarefa tarefa;
  final Function(bool?) onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TarefaCardItem({
    required this.tarefa,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color doneColor = Colors.grey[600]!;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: tarefa.isDone ? Colors.green : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        leading: Checkbox(
          value: tarefa.isDone,
          onChanged: onToggleDone,
          activeColor: primaryColor,
        ),
        title: Text(
          tarefa.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            decoration: tarefa.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: tarefa.isDone ? doneColor : null,
          ),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(DateTime.parse(tarefa.date)),
          style: TextStyle(color: tarefa.isDone ? doneColor : null),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.blue[600]),
              onPressed: onEdit,
              tooltip: 'Editar',
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red[600]),
              onPressed: onDelete,
              tooltip: 'Deletar',
            ),
          ],
        ),
      ),
    );
  }
}
