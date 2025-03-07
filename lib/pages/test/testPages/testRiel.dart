import 'package:flutter/material.dart';
import 'package:hc05_udipsai/services/bluetoothService.dart';

class TestRiel extends StatefulWidget {
  final BluetoothService bluetoothService;
  final String macAddress;

  const TestRiel({
    super.key,
    required this.bluetoothService,
    required this.macAddress,
  });

  @override
  _TestRielState createState() => _TestRielState();
}

class _TestRielState extends State<TestRiel> {
  String _receivedData = '';
  bool _areButtonsEnabled = false;
  bool _isPlayPressed = false;

  @override
  void initState() {
    super.initState();
    print("Dispositivo ya conectado desde TestPage");

    // Configurar el callback para recibir datos
    widget.bluetoothService.onDataReceivedCallback = (String data) {
      print("Datos recibidos en TestRiel: $data"); // Debug
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

  // Función para habilitar los botones
  void _enableButtons() {
    setState(() {
      _isPlayPressed = true;
      _areButtonsEnabled = true;
    });
  }

  // Función para cancelar (envía 'S' al Bluetooth y desactiva los botones)
  void _cancel() {
    widget.bluetoothService.sendData('S').then((_) {
      print("Comando 'S' enviado correctamente");
    }).catchError((error) {
      print("Error al enviar 'S': $error");
    });
    setState(() {
      _isPlayPressed = false;
      _areButtonsEnabled = false;
      _receivedData = ""; // Limpiar los datos recibidos
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test del Riel"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Primera columna (Botones)
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón Play que habilita los botones
                  FloatingActionButton(
                    onPressed: _enableButtons,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.play_arrow),
                  ),
                  SizedBox(height: 20),
                  // Botones para enviar mensajes al Bluetooth
                  _buildButton("Trayectoria 1", Colors.blue, "M1"),
                  SizedBox(height: 10),
                  _buildButton("Trayectoria 2", Colors.red, "M2"),
                  SizedBox(height: 10),
                  _buildButton("Trayectoria 3", Colors.green, "M3"),
                  SizedBox(height: 20),
                  // Botón Cancelar que envía 'S' y limpia la pantalla
                  if (_isPlayPressed)
                    FloatingActionButton(
                      onPressed: _cancel,
                      backgroundColor: Colors.yellow,
                      child: Icon(Icons.restart_alt),
                    ),
                ],
              ),
            ),
            SizedBox(width: 20), // Espaciado entre columnas
            // Segunda columna (Card con los resultados)
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
                    child: SingleChildScrollView(
                      child: Text(
                        _receivedData.isNotEmpty
                            ? _receivedData
                            : "Esperando datos del dispositivo...",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
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

  // Método para construir los botones con la funcionalidad de Bluetooth
  Widget _buildButton(String text, Color color, String message) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _areButtonsEnabled
            ? () {
          _sendBluetoothMessage(message); // Enviar el mensaje correspondiente al Bluetooth
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