import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentInfoScreen(),
    );
  }
}

class StudentInfoScreen extends StatefulWidget {
  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informações do Aluno')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Aluno'),
            ),
            TextField(
              controller: _registrationController,
              decoration: InputDecoration(labelText: 'Matrícula'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String registration = _registrationController.text;

                if (name.isNotEmpty && registration.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEntryScreen(
                        name: name,
                        registration: registration,
                      ),
                    ),
                  );
                }
              },
              child: Text('Próxima'),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteEntryScreen extends StatefulWidget {
  final String name;
  final String registration;

  NoteEntryScreen({required this.name, required this.registration});

  @override
  _NoteEntryScreenState createState() => _NoteEntryScreenState();
}

class _NoteEntryScreenState extends State<NoteEntryScreen> {
  final TextEditingController _noteController = TextEditingController();
  List<double> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lançar Notas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Digite uma Nota'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double note = double.tryParse(_noteController.text) ?? 0;
                if (note > 0) {
                  setState(() {
                    notes.add(note);
                  });
                  _noteController.clear();
                }
              },
              child: Text('Adicionar Nota'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (notes.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentSummaryScreen(
                        name: widget.name,
                        registration: widget.registration,
                        notes: notes,
                      ),
                    ),
                  );
                }
              },
              child: Text('Ver Notas'),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentSummaryScreen extends StatelessWidget {
  final String name;
  final String registration;
  final List<double> notes;

  StudentSummaryScreen({
    required this.name,
    required this.registration,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resumo do Aluno')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nome: $name', style: TextStyle(fontSize: 20)),
            Text('Matrícula: $registration', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Notas:'),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Nota ${index + 1}: ${notes[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
