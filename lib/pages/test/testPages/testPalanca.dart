import 'package:flutter/material.dart';
import 'package:hc05_udipsai/services/bluetoothService.dart';

class TestPalanca extends StatefulWidget {
  final BluetoothService bluetoothService;
  final String macAddress;

  const TestPalanca({
    super.key,
    required this.bluetoothService,
    required this.macAddress,
  });

  @override
  State<TestPalanca> createState() => _TestPalancaPageState();
}

class _TestPalancaPageState extends State<TestPalanca> {
  String _receivedData = "";

  @override
  void initState() {
    super.initState();

    widget.bluetoothService.onDataReceivedCallback = (String data) {
      setState(() {
        _receivedData += data + "\n"; // Agregar un salto de línea para separar las respuestas
      });
    };
  }


  @override
  void dispose() {
    widget.bluetoothService.disconnectFromDevice();
    widget.bluetoothService.onDataReceivedCallback = null;
    super.dispose();
  }

  // Enviar "M1" al módulo Bluetooth
  void _sendM1Command() {
    widget.bluetoothService.sendData('M1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monotonía M1"),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón para enviar "M1"
            ElevatedButton(
              onPressed: _sendM1Command,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                "Enviar M1",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Área para mostrar los datos recibidos
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        _receivedData.isNotEmpty
                            ? _receivedData
                            : "Esperando datos del dispositivo...",
                        style: const TextStyle(
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
    );
  }
}
