import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:hc05_udipsai/services/bluetoothService.dart'; // Asegúrate de tener este servicio de Bluetooth

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
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<Uint8List>? _bluetoothSubscription;

  List<int> _byteBuffer = [];
  final _utf8Decoder = utf8.decoder;

  bool _areButtonsEnabled = false;
  bool _isPlayPressed = false;

  @override
  void initState() {
    super.initState();

    // Conectar al dispositivo Bluetooth usando la dirección MAC
    widget.bluetoothService.connectToDevice(widget.macAddress);

    // Configurar el callback para recibir datos
    widget.bluetoothService.onDataReceivedCallback = (String data) {
      setState(() {
        _receivedData += data;
      });
    };
  }

  // Procesa los datos recibidos del Bluetooth
  void _processIncomingData(Uint8List newData) {
    _byteBuffer.addAll(newData); // Añadir nuevos datos al buffer

    // Buscar delimitadores de fin de mensaje (ej. '\n')
    int endIndex = _byteBuffer.lastIndexOf(10); // 10 = ASCII para '\n'

    if (endIndex != -1) {
      // Convertir la parte del buffer hasta el delimitador a string
      String decoded = utf8.decode(_byteBuffer.sublist(0, endIndex));

      // Actualizar el buffer para que contenga los datos restantes después del delimitador
      _byteBuffer = _byteBuffer.sublist(endIndex + 1);

      // Agregar los datos decodificados a la variable _receivedData
      setState(() {
        _receivedData += decoded.trim() + '\n'; // Usamos trim() para eliminar posibles saltos de línea extras
      });
    }
  }

  // Función para habilitar los botones de control
  void _enableButtons() {
    setState(() {
      _isPlayPressed = true;
      _areButtonsEnabled = true;
    });
  }

  // Función para cancelar (envía 'S' al Bluetooth y desactiva los botones)
  void _cancel() {
    widget.bluetoothService.sendData('S'); // Enviar 'S' al dispositivo Bluetooth
    setState(() {
      _isPlayPressed = false;
      _areButtonsEnabled = false;
      _receivedData = ""; // Limpiar los datos recibidos
    });
  }

  @override
  void dispose() {
    widget.bluetoothService.disconnectFromDevice(); // Desconectar del dispositivo al salir
    widget.bluetoothService.onDataReceivedCallback = null;
    super.dispose();
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
                  _buildButton("Trayectoria 2", Colors.red, "M1"),
                  SizedBox(height: 10),
                  _buildButton("Trayectoria 3", Colors.green, "M1"),
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
          widget.bluetoothService.sendData(message); // Enviar el mensaje correspondiente al Bluetooth
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
