import 'package:flutter/material.dart';
import 'package:hc05_udipsai/components/itemPaciente.dart';
import 'package:hc05_udipsai/models/pacientes.dart';
import 'package:hc05_udipsai/pages/paciente/crudPaciente/pacienteAgregar.dart';
import 'package:hc05_udipsai/pages/paciente/crudPaciente/pacienteEditar.dart';
import 'package:hc05_udipsai/services/firebase_service.dart';
import 'package:provider/provider.dart';


class PacientesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pacientes'),
      ),
      body: StreamBuilder<List<Paciente>>(
        stream: Provider.of<PacienteService>(context).obtenerPacientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pacientes = snapshot.data!;
          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              return PacienteItem(
                paciente: pacientes[index],
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditarPacienteScreen(paciente: pacientes[index]),
                    ),
                  );
                },
                onDelete: () {
                  Provider.of<PacienteService>(context, listen: false)
                      .eliminarPaciente(pacientes[index].id!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarPacienteScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}