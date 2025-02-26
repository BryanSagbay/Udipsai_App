import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

class Monotonia extends StatefulWidget {
  final BluetoothClassic bluetooth = BluetoothClassic();  // Bluetooth instance

  @override
  _MonotoniaState createState() => _MonotoniaState();
}

class _MonotoniaState extends State<Monotonia> {
  String? _selectedOption;
  final List<String> _options = ['Aleatoriamente', 'Horario', 'Antihorario'];
  bool _isDropdownEnabled = false;
  bool _areButtonsEnabled = false;
  bool _showCancelButton = false;

  // Función para enviar mensaje al Bluetooth
  Future<void> _sendBluetoothMessage(String message) async {
    try {
      await widget.bluetooth.write(message);
      print("Mensaje enviado: $message");
    } catch (e) {
      print("Error al enviar mensaje: $e");
    }
  }

  void _resetState() {
    setState(() {
      _isDropdownEnabled = false;
      _areButtonsEnabled = false;
      _selectedOption = null;
      _showCancelButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monotonía y Reacción Test"),
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
                  _buildButton("Botón 1", Colors.red, "rojo"),
                  SizedBox(height: 10),
                  _buildButton("Botón 3", Colors.blue, "azul"),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Botón 2", Colors.yellow, "amarillo"),
                  SizedBox(height: 10),
                  _buildButton("Botón 4", Colors.green, "verde"),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Column(
                children: [
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
                        hint: Text("Seleccione una opción"),
                        isExpanded: true,
                        onChanged: _isDropdownEnabled
                            ? (String? newValue) {
                          setState(() {
                            _selectedOption = newValue!;
                            _areButtonsEnabled = true;
                          });
                          // Enviar la opción seleccionada al Bluetooth
                          if (_selectedOption == 'Aleatoriamente') {
                            _sendBluetoothMessage('M1');
                          } else if (_selectedOption == 'Horario') {
                            _sendBluetoothMessage('M2');
                          } else if (_selectedOption == 'Antihorario') {
                            _sendBluetoothMessage('M3');
                          }
                        }
                            : null,
                        items: _options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                            _selectedOption != null
                                ? "Modo seleccionado: $_selectedOption"
                                : "Seleccione un modo",
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_showCancelButton)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _sendBluetoothMessage('S');
                    _resetState();
                  },
                  backgroundColor: Colors.red,
                  child: Icon(Icons.cancel, color: Colors.white),
                ),
              ),
            FloatingActionButton(
              onPressed: _isDropdownEnabled
                  ? null
                  : () {
                setState(() {
                  _isDropdownEnabled = true;
                  _showCancelButton = true;
                });
              },
              backgroundColor: _isDropdownEnabled ? Colors.grey : Colors.blue,
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildButton(String text, Color color, String message) {
    return SizedBox(
      width: 200,
      height: 200,
      child: ElevatedButton(
        onPressed: _areButtonsEnabled
            ? () {
          // Enviar el mensaje correspondiente al Bluetooth
          _sendBluetoothMessage(message);
          print("$text presionado");
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );
  }
}
