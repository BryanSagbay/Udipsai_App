import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hc05_udipsai/models/pacientes.dart';

class PacienteService {
  final CollectionReference pacientes =
  FirebaseFirestore.instance.collection('pacientes');

  // Crear un paciente con un contador autoincremental
  Future<void> agregarPaciente(Paciente paciente) async {
    // Obtener el último contador
    final query = await pacientes.orderBy('contador', descending: true).limit(1).get();
    int ultimoContador = 0;

    if (query.docs.isNotEmpty) {
      ultimoContador = query.docs.first['contador'];
    }

    // Asignar el nuevo contador
    paciente.contador = ultimoContador + 1;

    // Agregar el paciente a Firestore
    await pacientes.add(paciente.toMap());
  }

  // Leer pacientes y ordenar por contador descendente
  Stream<List<Paciente>> obtenerPacientes() {
    return pacientes.orderBy('contador', descending: true).snapshots().map((snapshot) {
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