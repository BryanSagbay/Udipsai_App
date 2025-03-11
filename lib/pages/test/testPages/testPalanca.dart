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
  bool _isButton1Enabled = false;
  double leftColumnWidth = 0.4; // Personalizable
  double rightColumnWidth = 0.6; // Personalizable
  double cardHeight = 400; // Personalizable
  bool _isLoading = false; // Para controlar la animación de carga

  @override
  void initState() {
    super.initState();
    widget.bluetoothService.onDataReceivedCallback = (String data) {
      print("Datos recibidos: $data");  // Verifica si los datos están siendo recibidos
      setState(() {
        if (data.isNotEmpty) {
          _receivedData = data; // Ahora reemplaza en vez de concatenar
          _isLoading = false; // Detener la animación cuando llegan datos
        }
      });
    };
  }

  @override
  void dispose() {
    widget.bluetoothService.disconnectFromDevice();
    widget.bluetoothService.onDataReceivedCallback = null;
    super.dispose();
  }

  void _sendM1Command() {
    if (_isButton1Enabled) {
      setState(() {
        _isLoading = true; // Activar la animación de carga
      });
      widget.bluetoothService.sendData('M1');
    }
  }

  void _toggleStart() {
    setState(() {
      _isButton1Enabled = true;
    });
  }

  void _reset() {
    widget.bluetoothService.sendData('S');

    setState(() {
      _isButton1Enabled = false;
      _receivedData = "";
      _isLoading = false; // Detener animación en el reset
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            Image.asset(
              'assets/images/ucacuelogo.png',
              height: 30, // Ajusta el tamaño del logo
            ),
            const SizedBox(width: 8), // Espaciado entre imágenes
            Image.asset(
              'assets/images/udipsai.png', // Nueva imagen
              height: 30, // Ajusta el tamaño
            ),
            const SizedBox(width: 16), // Más espacio antes del texto
            const Text(
              "Monotonía M1",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ofertafond.jpg'), // Fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              // Lado izquierdo - Botón Enviar M1
              Expanded(
                flex: (leftColumnWidth * 10).toInt(),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isButton1Enabled ? _sendM1Command : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Enviar M1",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Lado derecho - Card con respuesta del Bluetooth
              Expanded(
                flex: (rightColumnWidth * 10).toInt(),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: cardHeight,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: _isLoading
                            ? _buildLoadingAnimation()
                            : SingleChildScrollView(
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
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 30), // Para mover los botones a la izquierda
          FloatingActionButton(
            onPressed: _toggleStart,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.play_arrow),
          ),
          if (_isButton1Enabled) ...[
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _reset,
              backgroundColor: Colors.yellow,
              tooltip: 'Reiniciar y enviar S',
              child: const Icon(Icons.refresh),
            ),
          ]
        ],
      ),
    );
  }

  // Widget para la animación de carga
  Widget _buildLoadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.gamepad,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Procesando test...",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
        ),
      ],
    );
  }
}
