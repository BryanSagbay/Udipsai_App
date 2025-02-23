import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final String pacienteId;
  final String pacienteNombre;

  TestPage({required this.pacienteId, required this.pacienteNombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tests'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Paciente seleccionado: $pacienteNombre'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Test 1 seleccionado para $pacienteNombre'); // Depuración
              },
              child: Text('Test 1'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Test 2 seleccionado para $pacienteNombre'); // Depuración
              },
              child: Text('Test 2'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Test 3 seleccionado para $pacienteNombre'); // Depuración
              },
              child: Text('Test 3'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Test 4 seleccionado para $pacienteNombre'); // Depuración
              },
              child: Text('Test 4'),
            ),
          ],
        ),
      ),
    );
  }
}