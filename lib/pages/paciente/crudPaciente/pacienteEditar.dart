import 'package:flutter/material.dart';
import 'package:hc05_udipsai/models/pacientes.dart';
import 'package:hc05_udipsai/services/firebase_service.dart';
import 'package:provider/provider.dart';

class EditarPacienteScreen extends StatefulWidget {
  final Paciente paciente;

  EditarPacienteScreen({required this.paciente});

  @override
  _EditarPacienteScreenState createState() => _EditarPacienteScreenState();
}

class _EditarPacienteScreenState extends State<EditarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _direccionController;
  late TextEditingController _edadController;
  late TextEditingController _generoController;
  late TextEditingController _telefonoController;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores actuales del paciente
    _nombreController = TextEditingController(text: widget.paciente.nombre);
    _apellidoController = TextEditingController(text: widget.paciente.apellido);
    _direccionController = TextEditingController(text: widget.paciente.direccion);
    _edadController = TextEditingController(text: widget.paciente.edad.toString());
    _generoController = TextEditingController(text: widget.paciente.genero);
    _telefonoController = TextEditingController(text: widget.paciente.telefono);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Paciente'),
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
              // Botón para actualizar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Crear un objeto Paciente con los datos actualizados
                    final paciente = Paciente(
                      id: widget.paciente.id, // Mantener el mismo ID
                      nombre: _nombreController.text,
                      apellido: _apellidoController.text,
                      direccion: _direccionController.text,
                      edad: int.parse(_edadController.text),
                      genero: _generoController.text,
                      telefono: _telefonoController.text,
                      contador: widget.paciente.contador, // Mantener el mismo contador
                    );

                    // Actualizar el paciente en Firestore
                    Provider.of<PacienteService>(context, listen: false)
                        .actualizarPaciente(paciente);

                    // Regresar a la pantalla anterior
                    Navigator.pop(context);
                  }
                },
                child: Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpiar los controladores cuando el widget se destruya
    _nombreController.dispose();
    _apellidoController.dispose();
    _direccionController.dispose();
    _edadController.dispose();
    _generoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}