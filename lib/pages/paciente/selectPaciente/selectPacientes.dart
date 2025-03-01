import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hc05_udipsai/pages/profile/profile.dart';
import 'package:hc05_udipsai/pages/test/homeTest/inicioTest.dart';

class SeleccionPacientePage extends StatefulWidget {
  final Function(String pacienteId, String pacienteNombre, String pacienteApellido) onPacienteSeleccionado;

  SeleccionPacientePage({required this.onPacienteSeleccionado});

  @override
  _SeleccionPacientePageState createState() => _SeleccionPacientePageState();
}

class _SeleccionPacientePageState extends State<SeleccionPacientePage> {
  bool _modalVisible = true; // Controlamos la visibilidad del modal manualmente

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/ofertafond.jpg', // Asegúrate de que esta imagen exista
              fit: BoxFit.cover,
            ),
          ),
          // Solo mostramos el modal si _modalVisible es true
          if (_modalVisible)
            _showPacienteDialog(context),
        ],
      ),
    );
  }

  // Mostrar el modal con los detalles del paciente
  Widget _showPacienteDialog(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Si se toca fuera del modal, redirigimos a ProfileScreen
        Navigator.of(context).pop(); // Cerrar el modal
        Navigator.of(context).pushReplacement( // Usamos pushReplacement para que no se quede en el stack
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(20),
          width: 700, // Limitar el ancho del modal
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selecciona un Paciente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              StreamBuilder<QuerySnapshot>(
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
                    shrinkWrap: true, // Para que el ListView ocupe solo el espacio necesario
                    itemCount: pacientes.length,
                    itemBuilder: (context, index) {
                      final paciente = pacientes[index].data() as Map<String, dynamic>;
                      final pacienteId = pacientes[index].id;
                      final pacienteNombre = paciente['nombre'] ?? 'Sin Nombre';
                      final pacienteApellido = paciente['apellido'] ?? '';

                      return ListTile(
                        title: Text('$pacienteNombre $pacienteApellido'),
                        onTap: () {
                          // Llamamos al método para pasar los datos al padre
                          widget.onPacienteSeleccionado(pacienteId, pacienteNombre, pacienteApellido);
                          setState(() {
                            _modalVisible = false; // Ocultar el modal
                          });
                          Navigator.of(context).pop(); // Cerrar el modal
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestPage(pacienteId: pacienteId, pacienteNombre: pacienteNombre, pacienteApellido: pacienteApellido),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Aquí redirigimos directamente a ProfileScreen sin usar pop() para evitar el fondo negro
                      Navigator.of(context).pop(); // Cerrar el modal
                      Navigator.of(context).pushReplacement( // Usamos pushReplacement para evitar el fondo negro
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
