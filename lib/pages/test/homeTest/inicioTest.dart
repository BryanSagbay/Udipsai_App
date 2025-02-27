import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:hc05_udipsai/pages/test/testPages/testPalanca.dart';
import 'package:hc05_udipsai/pages/test/testPages/testMonotonia.dart';
import 'package:hc05_udipsai/pages/test/testPages/testRiel.dart';
import 'package:hc05_udipsai/pages/test/testPages/testTuercas.dart';
import 'dart:async';

class TestPage extends StatefulWidget {
  final String pacienteId;
  final String pacienteNombre;
  final String pacienteApellido;

  TestPage({required this.pacienteId, required this.pacienteNombre, required this.pacienteApellido});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _bluetoothClassicPlugin = BluetoothClassic();
  bool _isConnected = false;
  String? _connectedDeviceAddress;
  double _opacity = 0.0;
  double _positionY = -200;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
        _positionY = 100;
      });
    });
  }

  Future<void> _connectToDevice(String macAddress) async {
    String serviceUuid = "00001101-0000-1000-8000-00805f9b34fb";
    try {
      await _bluetoothClassicPlugin.connect(macAddress, serviceUuid);
      setState(() {
        _isConnected = true;
        _connectedDeviceAddress = macAddress;
      });
      _showSnackBar('Conectado a $macAddress', Colors.green);
    } catch (e) {
      _showSnackBar('Error al conectar: $e', Colors.red);
    }
  }

  Future<void> _disconnectDevice() async {
    if (_isConnected) {
      try {
        await _bluetoothClassicPlugin.disconnect();
        setState(() {
          _isConnected = false;
          _connectedDeviceAddress = null;
        });
        _showSnackBar('Desconectado', Colors.orange);
      } catch (e) {
        _showSnackBar('Error al desconectar: $e', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  @override
  void dispose() {
    _disconnectDevice();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _disconnectDevice();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Fondo de la página
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/fondo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Animación del águila
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              curve: Curves.easeOut,
              top: _positionY,
              left: MediaQuery.of(context).size.width / 2 - 100,
              child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: _opacity,
                child: Image.asset(
                  'lib/images/aguila.png',
                  width: 260,
                  height: 230,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3838),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PACIENTE SELECCIONADO: \n",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "${widget.pacienteNombre} ${widget.pacienteApellido}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTestButton('lib/images/test/testMonotonia.png', Monotonia(), "98:D3:71:FD:80:8B"),
                        _buildTestButton('lib/images/test/testRiel.png', TestRiel(), "98:D3:31:F6:5D:9D"),
                        _buildTestButton('lib/images/test/testPalanca.png', TestPalanca(), "00:22:03:01:3C:45"),
                        _buildTestButton('lib/images/test/testTuercas.png', TestTuercas(), "98:D3:11:FC:3B:3D"),
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

  Widget _buildTestButton(String imagePath, Widget nextPage, String macAddress) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await _connectToDevice(macAddress);
          if (_isConnected) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextPage),
            ).then((_) async {
              await _disconnectDevice();
            });
          }
        },
        child: Container(
          width: 140,
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
