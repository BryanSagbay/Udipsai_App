import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'dart:typed_data';
import 'dart:convert';

class TestTuercas extends StatefulWidget {
  @override
  _TestTuercasState createState() => _TestTuercasState();
}

class _TestTuercasState extends State<TestTuercas> {
  final BluetoothClassic _bluetooth = BluetoothClassic(); // Instancia interna de Bluetooth
  String _receivedData = '';
  final ScrollController _scrollController = ScrollController();
  List<int> _byteBuffer = [];
  final _utf8Decoder = utf8.decoder;
  bool _areButtonsEnabled = false; // Estado para habilitar/deshabilitar botones
  bool _showCancelButton = false; // Estado para mostrar/ocultar el botón de cancelar

  @override
  void initState() {
    super.initState();
    _startBluetoothListener();
  }

  // Función para recibir datos Bluetooth
  void _startBluetoothListener() {
    _bluetooth.onDeviceDataReceived().listen((Uint8List data) {
      _processIncomingData(data);
    });
  }

  // Procesa los datos recibidos
  void _processIncomingData(Uint8List newData) {
    _byteBuffer.addAll(newData);
    int endIndex = _byteBuffer.lastIndexOf(10); // ASCII para '\n'

    if (endIndex != -1) {
      String decoded = utf8.decode(_byteBuffer.sublist(0, endIndex));
      _byteBuffer = _byteBuffer.sublist(endIndex + 1);

      setState(() {
        _receivedData += decoded.trim() + '\n';
      });
    }
  }

  // Enviar mensaje por Bluetooth
  Future<void> _sendBluetoothMessage(String message) async {
    try {
      await _bluetooth.write(message);
      print("Mensaje enviado: $message");
    } catch (e) {
      print("Error al enviar mensaje: $e");
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
                    controller: _scrollController,
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