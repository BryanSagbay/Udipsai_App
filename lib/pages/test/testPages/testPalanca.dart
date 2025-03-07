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
  State<TestPalanca> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<TestPalanca> {
  String _receivedData = "";
  bool _isPlayPressed = false;
  bool _areButtonsEnabled = false;

  @override
  void initState() {
    super.initState();
    print("Dispositivo ya conectado desde TestPage");

    // Configurar el callback para recibir datos
    widget.bluetoothService.onDataReceivedCallback = (String data) {
      print("Datos recibidos en TestPalanca: $data"); // Debug
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

  void _play() {
    print("Habilitando botones...");
    setState(() {
      _isPlayPressed = true;
      _areButtonsEnabled = true;
    });
  }

  void _cancel() {
    print("Botón Cancelar presionado");
    widget.bluetoothService.sendData('S').then((_) {
      print("Comando 'S' enviado correctamente");
    }).catchError((error) {
      print("Error al enviar 'S': $error");
    });
    setState(() {
      _isPlayPressed = false;
      _areButtonsEnabled = false;
      _receivedData = "";
    });
  }

  void _sendM1() {
    try {
      widget.bluetoothService.sendData('M1');
      print("M1 enviado correctamente");
    } catch (error) {
      print("Error al enviar M1: $error");
    }
  }

  // Repite para _sendM2 y _sendM3

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test de Palanca"),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Row(
          children: [
            // Columna izquierda con botones
            SizedBox(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _areButtonsEnabled ? _sendM1 : null,
                    child: Text('Enviar M1'),
                  ),
                  // Repite para M2 y M3
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Card para datos recibidos
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FloatingActionButton(
            onPressed: _play,
            backgroundColor: Colors.blue,
            child: Icon(Icons.play_arrow),
          ),
          if (_isPlayPressed) ...[
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _cancel,
              backgroundColor: Colors.yellow,
              child: Icon(Icons.restart_alt),
            ),
          ]
        ],
      ),
    );
  }
}