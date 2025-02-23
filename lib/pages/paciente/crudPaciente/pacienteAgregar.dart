import 'package:flutter/material.dart';
import 'package:hc05_udipsai/models/pacientes.dart';
import 'package:hc05_udipsai/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgregarPacienteScreen extends StatefulWidget {
  @override
  _AgregarPacienteScreenState createState() => _AgregarPacienteScreenState();
}

class _AgregarPacienteScreenState extends State<AgregarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _edadController = TextEditingController();
  final _generoController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo para el nombre
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un nombre';
                  }
                  return null;
                },
              ),
              // Campo para el apellido
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un apellido';
                  }
                  return null;
                },
              ),
              // Campo para la dirección
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese una dirección';
                  }
                  return null;
                },
              ),
              // Campo para la edad
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese una edad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              // Campo para el género
              TextFormField(
                controller: _generoController,
                decoration: InputDecoration(labelText: 'Género'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un género';
                  }
                  return null;
                },
              ),
              // Campo para el teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un teléfono';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Botón para guardar
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Obtener el último contador desde Firestore
                    final query = await FirebaseFirestore.instance
                        .collection('pacientes')
                        .orderBy('contador', descending: true)
                        .limit(1)
                        .get();

                    int ultimoContador = 0;
                    if (query.docs.isNotEmpty) {
                      ultimoContador = query.docs.first['contador'];
                    }

                    // Crear un objeto Paciente con los datos ingresados
                    final paciente = Paciente(
                      nombre: _nombreController.text,
                      apellido: _apellidoController.text,
                      direccion: _direccionController.text,
                      edad: int.parse(_edadController.text),
                      genero: _generoController.text,
                      telefono: _telefonoController.text,
                      contador: ultimoContador + 1, // Asignar el nuevo contador
                    );

                    // Agregar el paciente a Firestore
                    Provider.of<PacienteService>(context, listen: false)
                        .agregarPaciente(paciente);

                    // Regresar a la pantalla anterior
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}