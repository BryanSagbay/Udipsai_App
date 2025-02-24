import 'package:flutter/material.dart';

class Monotonia extends StatelessWidget {
  final String testName;

  Monotonia({required this.testName});

  final List<Color> buttonColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
  ]; // Lista de colores para los 8 botones

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Tarjeta con el título del test
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'Test de Monotonía',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Espaciado entre la card y los botones
            // Grid con 8 botones (2 columnas x 4 filas)
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columnas
                  crossAxisSpacing: 20, // Espacio horizontal
                  mainAxisSpacing: 20, // Espacio vertical
                  childAspectRatio: 5, // Relación de aspecto para botones más anchos
                ),
                itemCount: 8, // 8 botones
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      _mostrarModalCentro(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColors[index], // Color dinámico
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Botón ${index + 1}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para mostrar el modal en el centro
  void _mostrarModalCentro(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar tocando fuera del modal
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Texto superior con estilo moderno
              Text(
                "Seleccionar sentido del horario",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 15),
              // Botón 1: Horario (Mismo ancho que el botón de abajo)
              SizedBox(
                width: double.infinity, // Hace que el botón ocupe todo el ancho disponible
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                    print("Seleccionaste Horario");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Horario", style: TextStyle(fontSize: 18)),
                ),
              ),
              SizedBox(height: 10),
              // Botón 2: Antihorario (Mismo ancho que el botón de arriba)
              SizedBox(
                width: double.infinity, // Hace que el botón ocupe todo el ancho disponible
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                    print("Seleccionaste Antihorario");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Antihorario", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
