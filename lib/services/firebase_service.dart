import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hc05_udipsai/models/pacientes.dart';

class PacienteService {
  final CollectionReference pacientes =
  FirebaseFirestore.instance.collection('pacientes');

  // Crear un paciente
  Future<void> agregarPaciente(Paciente paciente) async {
    await pacientes.add(paciente.toMap());
  }

  // Leer pacientes
  Stream<List<Paciente>> obtenerPacientes() {
    return pacientes.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Paciente.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Actualizar un paciente
  Future<void> actualizarPaciente(Paciente paciente) async {
    await pacientes.doc(paciente.id).update(paciente.toMap());
  }

  // Eliminar un paciente
  Future<void> eliminarPaciente(String id) async {
    await pacientes.doc(id).delete();
  }
}