/* Precisará substituir a seguinte linha do pubspec.yaml:
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.17.0  
  table_calendar: ^3.0.0  

Após adicionar essas linhas, execute no terminal do vs code o comando abaixo:
flutter pub get

Com isso, irá poder utilizar o import das bibliotecas intl, e table_calendar
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendário do Mês Atual')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DayDetailScreen(selectedDay: selectedDay),
                ),
              );
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
        ],
      ),
    );
  }
}

class DayDetailScreen extends StatelessWidget {
  final DateTime selectedDay;

  DayDetailScreen({required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    String dayOfWeek = DateFormat('EEEE').format(selectedDay);
    String dayOfMonth = DateFormat('d').format(selectedDay);

    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Dia')),
      body: Center(
        child: Text(
          'Apertado: $dayOfWeek, $dayOfMonth',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
