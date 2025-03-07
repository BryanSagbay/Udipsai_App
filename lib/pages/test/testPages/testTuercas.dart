import 'package:flutter/material.dart';
import 'package:hc05_udipsai/services/bluetoothService.dart';

class TestTuercas extends StatefulWidget {
  final BluetoothService bluetoothService;
  final String macAddress;

  const TestTuercas({
    super.key,
    required this.bluetoothService,
    required this.macAddress,
  });

  @override
  _TestTuercasState createState() => _TestTuercasState();
}

class _TestTuercasState extends State<TestTuercas> {
  String _receivedData = '';
  bool _areButtonsEnabled = false;
  bool _showCancelButton = false;
  @override
  void initState() {
    super.initState();

    // Configurar el callback para recibir datos
    widget.bluetoothService.onDataReceivedCallback = (String data) {
      setState(() {
        _receivedData += data;
      });
    };
  }



  @override
  void dispose() {
    widget.bluetoothService.disconnectFromDevice();
    widget.bluetoothService.onDataReceivedCallback = null;
    super.dispose();
  }

  // Enviar mensaje al Bluetooth
  void _sendBluetoothMessage(String message) {
    try {
      widget.bluetoothService.sendData(message);
      print("Mensaje '$message' enviado correctamente");
    } catch (error) {
      print("Error al enviar '$message': $error");
    }
  }

  // Reiniciar el estado
  void _resetState() {
    setState(() {
      _areButtonsEnabled = false;
      _showCancelButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test de Tuercas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Primera columna (3 botones)
            Expanded(
              flex: 1, // Ajusta el espacio para la columna de botones
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Botón 1", Colors.blue, "M1"),
                  SizedBox(height: 10),
                  _buildButton("Botón 2", Colors.red, "M2"),
                  SizedBox(height: 10),
                  _buildButton("Botón 3", Colors.green, "M3"),
                ],
              ),
            ),
            SizedBox(width: 20), // Espaciado entre columnas
            // Segunda columna (Card para datos recibidos)
            Expanded(
              flex: 2, // Ajusta el espacio para la tarjeta
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        _receivedData.isNotEmpty
                            ? _receivedData
                            : "Esperando datos del dispositivo...",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
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
            // Botón de reinicio (envía "r")
            FloatingActionButton(
              heroTag: "btnReiniciar", // <-- Agrega un tag único
              onPressed: () {
                _sendBluetoothMessage('r');
                print("Reinicio presionado");
              },
              backgroundColor: Colors.orange,
              child: Icon(Icons.refresh, color: Colors.white),
            ),
            SizedBox(width: 10), // Espaciado entre botones
            // Botón de cancelar (envía "S")
            if (_showCancelButton)
              FloatingActionButton(
                heroTag: "btnCancelar", // <-- Agrega un tag único
                onPressed: () {
                  _sendBluetoothMessage('S');
                  _resetState();
                  print("Cancelar presionado");
                },
                backgroundColor: Colors.red,
                child: Icon(Icons.cancel, color: Colors.white),
              ),
            SizedBox(width: 10), // Espaciado entre botones
            // Botón de inicio (habilita los botones)
            FloatingActionButton(
              heroTag: "btnInicio", // <-- Agrega un tag único
              onPressed: _areButtonsEnabled
                  ? null
                  : () {
                setState(() {
                  _areButtonsEnabled = true;
                  _showCancelButton = true;
                });
                print("Inicio presionado");
              },
              backgroundColor: _areButtonsEnabled ? Colors.grey : Colors.blue,
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  // Método para construir botones con Bluetooth
  Widget _buildButton(String text, Color color, String message) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _areButtonsEnabled
            ? () {
          _sendBluetoothMessage(message);
          print("$text presionado");
        }
            : null,
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