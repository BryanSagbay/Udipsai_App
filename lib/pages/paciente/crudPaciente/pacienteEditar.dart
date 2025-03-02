import 'package:flutter/material.dart';
import 'package:hc05_udipsai/models/pacientes.dart';
import 'package:hc05_udipsai/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Importar el paquete

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Hacer el AppBar transparente
        elevation: 0, // Eliminar la sombra del AppBar
        title: const Text(
          'Editar Paciente',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fondo.jpg"), // Cambia por la ruta de tu imagen
                fit: BoxFit.cover, // Ajustar la imagen para cubrir toda la pantalla
              ),
            ),
          ),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Editar Paciente",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Actualice los detalles del paciente",
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
                            // Botón para actualizar
                            ElevatedButton(
                              onPressed: () async {
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
                                  await Provider.of<PacienteService>(context, listen: false)
                                      .actualizarPaciente(paciente);

                                  // Mostrar alerta de éxito
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success, // Corregido: 'success' en minúscula
                                    animType: AnimType.bottomSlide, // Corregido: 'bottomSlide' en minúscula
                                    title: 'Éxito',
                                    desc: 'Paciente actualizado correctamente.',
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
                              child: const Text("Actualizar"),
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
        ],
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

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);