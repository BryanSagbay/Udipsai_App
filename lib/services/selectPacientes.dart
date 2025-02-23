import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeleccionPacientePage extends StatelessWidget {
  final Function(String pacienteId) onPacienteSeleccionado;

  SeleccionPacientePage({required this.onPacienteSeleccionado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Paciente'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('pacientes')
            .orderBy('timestamp', descending: true) // Ordenar por timestamp
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar pacientes'));
          }
          final pacientes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final paciente = pacientes[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${paciente['nombre']} ${paciente['apellido']}'),
                onTap: () {
                  // Llama a la función callback con el ID del paciente seleccionado
                  onPacienteSeleccionado(pacientes[index].id);
                  Navigator.pop(context); // Cierra la página
                },
              );
            },
          );
        },
      ),
    );
  }
}