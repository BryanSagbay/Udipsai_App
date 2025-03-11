import 'package:flutter/material.dart';
import 'package:hc05_udipsai/pages/test/testPages/testPalanca.dart';
import 'package:hc05_udipsai/pages/test/testPages/testMonotonia.dart';
import 'package:hc05_udipsai/pages/test/testPages/testRiel.dart';
import 'package:hc05_udipsai/pages/test/testPages/testTuercas.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hc05_udipsai/services/bluetoothService.dart';

class TestPage extends StatefulWidget {
  final String pacienteId;
  final String pacienteNombre;
  final String pacienteApellido;

  TestPage({required this.pacienteId, required this.pacienteNombre, required this.pacienteApellido});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  final BluetoothService _bluetoothService = BluetoothService();
  bool _isConnected = false;
  String? _connectedDeviceAddress;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _controller;
  late Animation<Offset> _animation;

  // Variable para controlar si los botones están habilitados
  bool _buttonsEnabled = true;
  // Variable para controlar qué MAC está actualmente en proceso
  String? _processingMac;
  // Controlar si hay un diálogo visible
  bool _isDialogVisible = false;

  final List<Map<String, dynamic>> _devices = [
    {"mac": "98:D3:71:FD:80:8B", "screen": (BluetoothService service, String mac) => Monotonia(bluetoothService: service, macAddress: mac)},
    {"mac": "98:D3:31:F6:5D:9D", "screen": (BluetoothService service, String mac) => TestRiel(bluetoothService: service, macAddress: mac)},
    {"mac": "00:22:03:01:3C:45", "screen": (BluetoothService service, String mac) => TestPalanca(bluetoothService: service, macAddress: mac)},
    {"mac": "98:D3:11:FC:3B:3D", "screen": (BluetoothService service, String mac) => TestTuercas(bluetoothService: service, macAddress: mac)},
  ];


  @override
  void initState() {
    super.initState();
    _bluetoothService.init();

    // Configuración de la animación
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _bluetoothService.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // Función para mostrar el diálogo de espera
  void _showConnectionDialog(String testName) {
    if (!mounted) return;

    // Asegurarnos de que solo haya un diálogo visible a la vez
    if (_isDialogVisible) return;

    setState(() {
      _isDialogVisible = true;
    });

    // Usar Future.microtask para asegurar que el diálogo se muestre
    Future.microtask(() {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return WillPopScope(
            onWillPop: () async => false, // Prevenir cierre con botón atrás
            child: AlertDialog(
              title: Text("Conectando"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Estableciendo conexión con el dispositivo de $testName..."),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        // Cuando el diálogo se cierra, actualizar el estado
        if (mounted) {
          setState(() {
            _isDialogVisible = false;
          });
        }
      });
    });
  }

  // Función para cerrar el diálogo de espera
  void _closeConnectionDialog() {
    if (!mounted) return;

    if (_isDialogVisible) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _playErrorAudio() async {
    try {
      await _audioPlayer.play(AssetSource('audios/Error.mp3'));
    } catch (e) {
      print("Error reproduciendo audio: $e");
    }
  }

  Future<void> _connectToDevice(String macAddress, String audioPath, String testName) async {
    // Si los botones están deshabilitados o ya hay una conexión en proceso, no hacer nada
    if (!_buttonsEnabled || _processingMac != null) {
      return;
    }

    // Deshabilitar botones y establecer MAC en proceso
    setState(() {
      _buttonsEnabled = false;
      _processingMac = macAddress;
    });

    // Mostrar el diálogo de espera
    _showConnectionDialog(testName);

    // Importante: Usar Future.delayed para permitir que la UI se actualice
    // antes de iniciar la operación de conexión Bluetooth que puede bloquear
    await Future.delayed(Duration(milliseconds: 100));

    try {
      var device = _devices.firstWhere((device) => device["mac"] == macAddress, orElse: () => {});
      if (device.isNotEmpty) {
        // Usamos Future con timeout para evitar bloqueos prolongados
        bool connected = false;
        try {
          connected = await _bluetoothService.connectToDevice(macAddress)
              .timeout(Duration(seconds: 10), onTimeout: () {
            throw TimeoutException("La conexión tardó demasiado tiempo");
          });
        } catch (e) {
          print("Error de conexión: $e");
          connected = false;
        }

        // Cerrar el diálogo de espera
        _closeConnectionDialog();

        if (connected) {
          setState(() {
            _isConnected = true;
            _connectedDeviceAddress = macAddress;
          });

          await _playAudio(audioPath);

          // Envolvemos el Navigator.push en un Future.delayed para permitir
          // que el diálogo se cierre completamente primero
          await Future.delayed(Duration(milliseconds: 300));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => device["screen"](_bluetoothService, macAddress)),
          ).then((_) {
            if (mounted) {
              setState(() {
                _isConnected = false;
                _connectedDeviceAddress = null;
                _buttonsEnabled = true;  // Habilitar botones nuevamente
                _processingMac = null;   // Limpiar MAC en proceso
              });
            }
          });
        } else {
          // Si la conexión falló, reproducir audio de error
          await _playErrorAudio();
          // Mostrar mensaje de error
          _showSnackBar("No se pudo conectar al dispositivo. Verifique que esté encendido y dentro del rango.", Colors.red);

          if (mounted) {
            setState(() {
              _buttonsEnabled = true;
              _processingMac = null;
            });
          }
        }
      } else {
        // Cerrar diálogo y reproducir audio de error
        _closeConnectionDialog();
        await _playErrorAudio();
        _showSnackBar("Dispositivo no encontrado en la lista", Colors.red);

        if (mounted) {
          setState(() {
            _buttonsEnabled = true;
            _processingMac = null;
          });
        }
      }
    } catch (e) {
      // Manejar cualquier excepción durante el proceso
      print("Error en _connectToDevice: $e");
      _closeConnectionDialog();
      await _playErrorAudio();
      _showSnackBar("Error de conexión: ${e.toString()}", Colors.red);

      if (mounted) {
        setState(() {
          _buttonsEnabled = true;
          _processingMac = null;
        });
      }
    }
  }

  Future<void> _playAudio(String audioPath) async {
    try {
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print("Error reproduciendo audio: $e");
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _bluetoothService.disconnectFromDevice();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ofertafond.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Column(
                children: [
                  // Tarjeta del paciente seleccionado
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Texto justificado a la izquierda
                      children: [
                        Text(
                          'PACIENTE SELECCIONADO:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${widget.pacienteNombre} ${widget.pacienteApellido}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20), // Espacio entre la tarjeta y los botones
                  // Mover la animación del águila aquí, debajo de la tarjeta
                  SlideTransition(
                    position: _animation,
                    child: Center(
                      child: Image.asset(
                        'assets/images/aguila.png',
                        height: 135,
                      ),
                    ),
                  ),
                  SizedBox(height: 50), // Espacio entre la águila y los botones
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTestButton('Test de Monotonía', 'assets/images/test/testMonotonia.png', "98:D3:71:FD:80:8B", 'audios/TestMonotonia.mp3'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildTestButton('Sistema de Motrocidad', 'assets/images/test/testRiel.png', "98:D3:31:F6:5D:9D", 'audios/SistemaMotrocidad.mp3'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTestButton('Test de Palanca', 'assets/images/test/testPalanca.png', "00:22:03:01:3C:45", 'audios/TestPalanca.mp3'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildTestButton('Test de Bennett', 'assets/images/test/testTuercas.png', "98:D3:11:FC:3B:3D", 'audios/TestBennnett.mp3'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String text, String imagePath, String macAddress, String audioPath) {
    // Verificar si este botón específico está siendo procesado
    bool isProcessing = _processingMac == macAddress;
    // Calcular opacidad para indicar visualmente el estado del botón
    double opacity = (_buttonsEnabled && !isProcessing) ? 1.0 : 0.5;

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: (_buttonsEnabled && !isProcessing)
            ? () async {
          await _connectToDevice(macAddress, audioPath, text);
        }
            : null, // Si los botones están deshabilitados, no hacer nada al tocar
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Expansión del texto
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(64.0), // Espaciado alrededor del texto
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis, // Maneja el desbordamiento del texto si es necesario
                  ),
                ),
              ),
              // Imagen a la derecha
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.scaleDown,
                  height: 180, // Ajusta la altura según lo que necesites
                  width: 180,  // Ajusta el tamaño de la imagen
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Clase para manejar excepciones de timeout
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}