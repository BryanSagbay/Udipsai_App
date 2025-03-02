import 'package:flutter/material.dart';
import 'package:hc05_udipsai/models/pacientes.dart';
import 'package:hc05_udipsai/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Importar el paquete

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Agregar Paciente',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Agregar Nuevo Paciente",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Complete los detalles del paciente",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Campo para el nombre
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                            hintText: "Ingrese el nombre",
                            labelText: "Nombre",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese un nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Campo para el apellido
                        TextFormField(
                          controller: _apellidoController,
                          decoration: InputDecoration(
                            hintText: "Ingrese el apellido",
                            labelText: "Apellido",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese un apellido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Campo para la dirección
                        TextFormField(
                          controller: _direccionController,
                          decoration: InputDecoration(
                            hintText: "Ingrese la dirección",
                            labelText: "Dirección",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese una dirección';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Campo para la edad
                        TextFormField(
                          controller: _edadController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Ingrese la edad",
                            labelText: "Edad",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
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
                        const SizedBox(height: 24),
                        // Campo para el género
                        TextFormField(
                          controller: _generoController,
                          decoration: InputDecoration(
                            hintText: "Ingrese el género",
                            labelText: "Género",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese un género';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Campo para el teléfono
                        TextFormField(
                          controller: _telefonoController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Ingrese el teléfono",
                            labelText: "Teléfono",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: const TextStyle(color: Color(0xFF757575)),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            border: authOutlineInputBorder,
                            enabledBorder: authOutlineInputBorder,
                            focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese un teléfono';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
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
                              await Provider.of<PacienteService>(context, listen: false)
                                  .agregarPaciente(paciente);

                              // Mostrar alerta de éxito
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success, // Corregido: 'success' en minúscula
                                animType: AnimType.bottomSlide, // Corregido: 'bottomSlide' en minúscula
                                title: 'Éxito',
                                desc: 'El paciente se ha guardado correctamente.',
                                btnOkOnPress: () {
                                  // Regresar a la pantalla anterior después de presionar "OK"
                                  Navigator.pop(context);
                                },
                              ).show();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          child: const Text("Guardar"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);