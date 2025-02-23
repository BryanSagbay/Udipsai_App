import 'package:flutter/material.dart';
import 'package:hc05_udipsai/models/pacientes.dart';

class PacienteItem extends StatelessWidget {
  final Paciente paciente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  PacienteItem({
    required this.paciente,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${paciente.nombre} ${paciente.apellido}'),
      subtitle: Text('Edad: ${paciente.edad}, Teléfono: ${paciente.telefono}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}