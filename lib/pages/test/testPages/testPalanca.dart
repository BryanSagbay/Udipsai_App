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
  int _errores = 0;
  double _tiempoEjecucion = 0.0;
  bool _isButton1Enabled = false;
  bool _testCompleted = false;
  double leftColumnWidth = 0.4; // Personalizable
  double rightColumnWidth = 0.6; // Personalizable
  double cardHeight = 400; // Personalizable
  bool _isLoading = false; // Para controlar la animación de carga
  bool _isWaiting = true; // Para mostrar la animación de espera inicial

  @override
  void initState() {
    super.initState();
    widget.bluetoothService.onDataReceivedCallback = (String data) {
      print("Datos recibidos: $data");  // Verifica si los datos están siendo recibidos
      setState(() {
        if (data.isNotEmpty) {
          _receivedData = data; // Guardar los datos completos
          _processReceivedData(data); // Procesar los datos
          _isLoading = false; // Detener la animación cuando llegan datos
          _isWaiting = false; // Ya no está esperando
          _testCompleted = true; // Test completado
        }
      });
    };
  }

  // Método para procesar los datos recibidos separados por coma
  void _processReceivedData(String data) {
    // Eliminar los paréntesis de la cadena
    String cleanedData = data.replaceAll('(', '').replaceAll(')', '');

    // Dividir los datos por la coma
    if (cleanedData.contains(',')) {
      List<String> parts = cleanedData.split(',');
      if (parts.length >= 2) {
        try {
          // Asignar los valores a las variables correspondientes
          _errores = int.parse(parts[0].trim());
          _tiempoEjecucion = double.parse(parts[1].trim());
        } catch (e) {
          print("Error al parsear los datos: $e");
        }
      }
    }
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
        _isWaiting = false; // Ya no está esperando
        _testCompleted = false; // Reiniciar el estado de test completado
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
      _errores = 0;
      _tiempoEjecucion = 0.0;
      _isLoading = false; // Detener animación en el reset
      _isWaiting = true; // Volver a mostrar la animación de espera
      _testCompleted = false; // Reiniciar el estado de test completado
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Para separar las imágenes y el texto
          children: [
            Text(
              'Test de Palanca',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/ucacuelogo.png',
                  height: 45,
                ),
                SizedBox(width: 25),
                Image.asset(
                  'assets/images/udipsai.png',
                  height: 45,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ofertafond.jpg'), // Fondo con un rojo más suave
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.red.shade300.withOpacity(0.5), BlendMode.darken), // Fondo más suave
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
                        backgroundColor: Colors.grey.shade800, // Azul más suave
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
                      color: Colors.white70,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: _getCardContent(),
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
          const SizedBox(width: 30),
          FloatingActionButton(
            onPressed: _toggleStart,
            backgroundColor: Colors.green.shade600, // Azul para el botón
            child: const Icon(Icons.play_arrow),
          ),
          if (_isButton1Enabled) ...[
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _reset,
              backgroundColor: Colors.orange, // Naranja para el botón de reset
              tooltip: 'Reiniciar y enviar S',
              child: const Icon(Icons.refresh),
            ),
          ]
        ],
      ),
    );
  }

  // Método para determinar qué contenido mostrar en la tarjeta
  Widget _getCardContent() {
    if (_isLoading) {
      return _buildLoadingAnimation();
    } else if (_isWaiting) {
      return _buildWaitingAnimation();
    } else if (_testCompleted) {
      return _buildCompletedTest();
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Text(
            _receivedData.isNotEmpty
                ? _receivedData
                : "Esperando que se inicie el test...",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Color oscuro para el texto
            ),
          ),
        ),
      );
    }
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

  // Widget para la animación de espera inicial
  Widget _buildWaitingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Puedes usar un icono animado o Lottie Animation
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.hourglass_empty,
            size: 80,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Esperando que se inicie el test...",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Puedes agregar una animación pulsante aquí
        Container(
          width: 200,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.orange.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      ],
    );
  }

  // Widget para mostrar los resultados del test completado
  Widget _buildCompletedTest() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Card(
          elevation: 3,
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      "Errores: $_errores",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: Colors.blue.shade700, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      "Tiempo de ejecución: $_tiempoEjecucion",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Animación de test finalizado
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Test Finalizado",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}