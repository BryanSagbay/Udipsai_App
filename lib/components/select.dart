import 'package:flutter/material.dart';

class ModulosScreen extends StatelessWidget {
  final String pacienteId;

  ModulosScreen({required this.pacienteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Módulo'),
      ),
      body: Center(
        child: Text('Paciente ID: $pacienteId'),
      ),
    );
  }
}