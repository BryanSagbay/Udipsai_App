import 'package:flutter/material.dart';

class Monotonia extends StatefulWidget {
  @override
  _MonotoniaState createState() => _MonotoniaState();
}

class _MonotoniaState extends State<Monotonia> {
  String _selectedOption = 'Aletoriamente';
  final List<String> _options = ['Aletoriamente', 'Horario', 'Antihorario'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monotonia y Reaccion Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Botón 1", Colors.blue),
                  SizedBox(height: 10),
                  _buildButton("Botón 3", Colors.red),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Botón 2", Colors.purple),
                  SizedBox(height: 10),
                  _buildButton("Botón 4", Colors.teal),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  // Dropdown estilizado
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedOption,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue!;
                          });
                        },
                        items: _options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Card
                  Expanded(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
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
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color) {
    return SizedBox(
      width: 195,
      height: 155,
      child: ElevatedButton(
        onPressed: () {
          print("$text presionado");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );
  }
}
