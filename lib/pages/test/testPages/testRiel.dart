import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'dart:typed_data';
import 'dart:convert';

class TestRiel extends StatefulWidget {
  @override
  _TestRielState createState() => _TestRielState();
}

class _TestRielState extends State<TestRiel> {

  final BluetoothClassic _bluetooth = BluetoothClassic();

  String _receivedData = '';
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<Uint8List>? _bluetoothSubscription;

  List<int> _byteBuffer = [];
  final _utf8Decoder = utf8.decoder;

  @override
  void initState() {
    super.initState();

    if (_bluetoothSubscription == null || _bluetoothSubscription!.isPaused) {
      _startBluetoothListener();
    }
  }


  void _startBluetoothListener() {
    _bluetoothSubscription?.cancel(); // Cancela cualquier suscripción anterior

    _bluetoothSubscription = _bluetooth.onDeviceDataReceived().listen(
          (Uint8List data) {
        _processIncomingData(data);
      },
      onError: (error) {
        print("Error en Bluetooth: $error");
      },
      onDone: () {
        print("Stream finalizado.");
      },
      cancelOnError: true, // Cierra la suscripción si hay un error
    );
  }

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

  @override
  void dispose() {
    _bluetoothSubscription?.cancel();
    super.dispose();
  }

  Future<void> _sendBluetoothMessage(String message) async {
    try {
      await _bluetooth.write(message);
      print("Mensaje enviado: $message");
    } catch (e) {
      print("Error al enviar mensaje: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test del Riel"),
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
                  _buildButton("Trayectoria 1", Colors.blue, "M1"),
                  SizedBox(height: 10),
                  _buildButton("Trayectoria 2", Colors.red, "M1"),
                  SizedBox(height: 10),
                  _buildButton("Trayectoria 3", Colors.green, "M1"),
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

  // Método para construir botones con estilo
  Widget _buildButton(String text, Color color, String message) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _sendBluetoothMessage(message);
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