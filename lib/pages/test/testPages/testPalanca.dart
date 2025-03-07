import 'package:flutter/material.dart';
import 'package:hc05_udipsai/services/bluetoothService.dart';
import 'dart:convert';

class TestPalanca extends StatefulWidget {
  final BluetoothService bluetoothService;
  final String macAddress;

  const TestPalanca({
    super.key,
    required this.bluetoothService,
    required this.macAddress,
  });

  @override
  State<TestPalanca> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<TestPalanca> {
  String _receivedData = "";
  bool _isPlayPressed = false;
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

  // Función para enviar M1 y habilitar la recepción de datos
  void _play() {
    setState(() {
      _isPlayPressed = true;
      _areButtonsEnabled = true;
      _showCancelButton = true;
    });
  }

  // Función para cancelar (envía 'S' al Bluetooth y limpia los datos)
  void _cancel() {
    widget.bluetoothService.sendData('S');
    setState(() {
      _isPlayPressed = false;
      _areButtonsEnabled = false;
      _receivedData = ""; // Limpiar los datos recibidos
      _showCancelButton = false;
    });
  }

  // Funciones para enviar M2 y M3
  void _sendM(String message) {
    widget.bluetoothService.sendData(message);
  }

  // Método para construir botones con Bluetooth
  Widget _buildButton(String text, Color color, String message) {
    return SizedBox(
      width: double.infinity, // Asegura que los botones ocupen todo el ancho
      child: ElevatedButton(
        onPressed: _areButtonsEnabled
            ? () {
          _sendM(message);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test de Palanca"),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Columna izquierda con botones M1, M2, M3
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton("Enviar M2", Colors.blue, "M1"),
                  SizedBox(height: 10),
                  _buildButton("Enviar M3", Colors.red, "M1"),
                  SizedBox(height: 10),
                  _buildButton("Enviar M1", Colors.green, "M1"),
                ],
              ),
            ),
            const SizedBox(width: 20), // Espaciado entre columnas

            // Columna derecha con la Card ocupando toda la altura y ancho disponible
            Expanded(
              flex: 2,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Ajuste razonable para el padding
                  child: Center(
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
                  onPressed: _cancel,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.cancel, color: Colors.white),
                ),
              ),
            FloatingActionButton(
              onPressed: _isPlayPressed
                  ? null
                  : _play,
              backgroundColor: _isPlayPressed ? Colors.grey : Colors.blue,
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
