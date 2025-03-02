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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/ofertafond.jpg'), // Ruta de tu imagen de fondo
              fit: BoxFit.cover, // Ajuste de la imagen al tamaño del AppBar
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/ofertafond.jpg'), // Ruta de tu imagen de fondo
            fit: BoxFit.cover, // Ajuste de la imagen al tamaño de la pantalla
          ),
        ),
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
                  color: Colors.white, // Fondo negro para la card
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      pacientes[index].nombre,
                      style: TextStyle(color: Colors.black87), // Texto blanco
                    ),
                    subtitle: Text(
                      'Edad: ${pacientes[index].edad}',
                      style: TextStyle(color: Colors.black87), // Texto blanco
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón Editar con borde
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Color de fondo
                            side: BorderSide(color: Colors.white, width: 2), // Borde visible
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
                        // Botón Eliminar con borde
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Color de fondo
                            side: BorderSide(color: Colors.white, width: 2), // Borde visible
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
                              btnCancelOnPress: () {
                                // Acción cuando se cancela
                              },
                              btnOkOnPress: () {
                                // Eliminar paciente si el usuario confirma
                                Provider.of<PacienteService>(context, listen: false)
                                    .eliminarPaciente(pacientes[index].id!);
                              },
                              dialogBorderRadius: BorderRadius.zero, // Elimina el borde redondeado
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
