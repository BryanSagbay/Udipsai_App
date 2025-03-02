import 'package:flutter/material.dart';
import 'package:hc05_udipsai/models/pacientes.dart';
import 'package:hc05_udipsai/pages/paciente/crudPaciente/pacienteAgregar.dart';
import 'package:hc05_udipsai/pages/paciente/crudPaciente/pacienteEditar.dart';
import 'package:hc05_udipsai/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Importar el paquete

class PacientesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pacientes'),
      ),
      body: Container(
        child: StreamBuilder<List<Paciente>>(
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
                return Card(
                  color: Colors.white, // Fondo blanco para la card
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(
                      pacientes[index].nombre,
                      style: TextStyle(color: Colors.black87),
                    ),
                    subtitle: Text(
                      'Edad: ${pacientes[index].edad}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditarPacienteScreen(paciente: pacientes[index]),
                              ),
                            );
                          },
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            side: BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.noHeader,
                              animType: AnimType.bottomSlide,
                              title: '¿Estás seguro?',
                              desc: '¿Quieres eliminar este paciente?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () {
                                Provider.of<PacienteService>(context, listen: false)
                                    .eliminarPaciente(pacientes[index].id!);
                              },
                              dialogBorderRadius: BorderRadius.zero,
                            ).show();
                          },
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(40), // Define el border radius
        child: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Centra el botón
    );
  }
}
