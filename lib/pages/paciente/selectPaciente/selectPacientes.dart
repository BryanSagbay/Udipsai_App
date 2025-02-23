import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeleccionPacientePage extends StatelessWidget {
  final Function(String pacienteId, String pacienteNombre) onPacienteSeleccionado;

  SeleccionPacientePage({required this.onPacienteSeleccionado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Paciente'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pacientes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar pacientes'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay pacientes registrados.'));
          }

          final pacientes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final paciente = pacientes[index].data() as Map<String, dynamic>;
              final pacienteId = pacientes[index].id;
              final pacienteNombre = paciente['nombre'] ?? 'Sin Nombre';
              final pacienteApellido = paciente['apellido'] ?? '';

              return ListTile(
                title: Text('$pacienteNombre $pacienteApellido'),
                onTap: () {
                  print('Paciente seleccionado: $pacienteNombre'); // Depuración
                  onPacienteSeleccionado(pacienteId, pacienteNombre); // Ejecutar el callback
                },

              );
            },
          );
        },
      ),
    );
  }
}