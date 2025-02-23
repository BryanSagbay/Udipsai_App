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
          child: Column(
            children: [
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
              // Repite para los demás campos...
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final paciente = Paciente(
                      id: widget.paciente.id,
                      nombre: _nombreController.text,
                      apellido: _apellidoController.text,
                      direccion: _direccionController.text,
                      edad: int.parse(_edadController.text),
                      genero: _generoController.text,
                      telefono: _telefonoController.text,
                    );
                    Provider.of<PacienteService>(context, listen: false)
                        .actualizarPaciente(paciente);
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
}