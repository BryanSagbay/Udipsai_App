import 'package:flutter/material.dart';

class test4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Página"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Primera columna (3 botones)
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Botón 1", Colors.blue),
                  SizedBox(height: 10),
                  _buildButton("Botón 2", Colors.red),
                  SizedBox(height: 10),
                  _buildButton("Botón 3", Colors.green),
                ],
              ),
            ),
            SizedBox(width: 20), // Espaciado entre columnas
            // Segunda columna (Card)
            Expanded(
              flex: 2,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Contenido de la Card",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir botones con estilo
  Widget _buildButton(String text, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          print("$text presionado");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
