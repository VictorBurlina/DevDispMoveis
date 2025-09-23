import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DateInputScreen(),
    );
  }
}

class DateInputScreen extends StatefulWidget {
  @override
  _DateInputScreenState createState() => _DateInputScreenState();
}

class _DateInputScreenState extends State<DateInputScreen> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    setState(() {
      selectedDate = pickedDate;
    });

    if (pickedDate != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgeScreen(birthDate: pickedDate),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecione sua Data de Nascimento')),
      body: Center(
        child: ElevatedButton(
          onPressed: _selectDate,
          child: Text('Selecionar Data de Nascimento'),
        ),
      ),
    );
  }
}

class AgeScreen extends StatelessWidget {
  final DateTime birthDate;

  AgeScreen({required this.birthDate});

  @override
  Widget build(BuildContext context) {
    final int age = DateTime.now().year - birthDate.year;
    return Scaffold(
      appBar: AppBar(title: Text('Idade')),
      body: Center(
        child: Text('Sua idade é: $age anos'),
      ),
    );
  }
}
