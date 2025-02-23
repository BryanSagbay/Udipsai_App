class Paciente {
  String? id;
  String nombre;
  String apellido;
  String direccion;
  int edad;
  String genero;
  String telefono;
  int contador; // Campo contador

  Paciente({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.direccion,
    required this.edad,
    required this.genero,
    required this.telefono,
    required this.contador, // Campo contador es requerido
  });

  factory Paciente.fromMap(Map<String, dynamic> data, String id) {
    return Paciente(
      id: id,
      nombre: data['nombre'],
      apellido: data['apellido'],
      direccion: data['direccion'],
      edad: data['edad'],
      genero: data['genero'],
      telefono: data['telefono'],
      contador: data['contador'], // Campo contador
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'direccion': direccion,
      'edad': edad,
      'genero': genero,
      'telefono': telefono,
      'contador': contador, // Campo contador
    };
  }
}