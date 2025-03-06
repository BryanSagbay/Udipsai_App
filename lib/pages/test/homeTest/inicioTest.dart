import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:hc05_udipsai/pages/test/testPages/testPalanca.dart';
import 'package:hc05_udipsai/pages/test/testPages/testMonotonia.dart';
import 'package:hc05_udipsai/pages/test/testPages/testRiel.dart';
import 'package:hc05_udipsai/pages/test/testPages/testTuercas.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';



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
    _requestBluetoothPermissions();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _opacity = 1.0;
        _positionY = -10.0;
      });
    });
  }

  Future<void> _requestBluetoothPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.location.request().isGranted) {
      print("Permisos concedidos ✅");
    } else {
      print("Permisos denegados ❌");
    }
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
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black), // Flecha de retroceso blanca
            onPressed: () {
              Navigator.pop(context); // Acción para retroceder
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end, // Esto coloca el logo en el extremo derecho
            children: [
              Image.asset(
                'assets/images/definilylogo.png',
                height: 250, // Ajusta el tamaño del logo
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Fondo de la página
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ofertafond.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Animación del águila
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              curve: Curves.easeOut,
              top: _positionY,
              left: MediaQuery.of(context).size.width / 2 - 135,
              child: AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: _opacity,
                child: Image.asset(
                  'assets/images/aguila.png',
                  width: 300,
                  height: 370,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Información del paciente
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "PACIENTE SELECCIONADO:",
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                "${widget.pacienteNombre} ${widget.pacienteApellido}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 165),
                  // Contenedor para los botones
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          // Primera fila de botones
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTestButton('Test de Monotonía', 'assets/images/test/testMonotonia.png', Monotonia(), "98:D3:71:FD:80:8B"),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTestButton('Sistema de Motrocidad', 'assets/images/test/testRiel.png', TestRiel(), "98:D3:31:F6:5D:9D"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          // Segunda fila de botones
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildTestButton('Test de Palanca', 'assets/images/test/testPalanca.png', TestPalanca(), "00:22:03:01:3C:45"),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _buildTestButton('Test de Bennett', 'assets/images/test/testTuercas.png', TestTuercas(), "98:D3:11:FC:3B:3D"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildTestButton(String text, String imagePath, Widget nextPage, String macAddress) {
    return GestureDetector(
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(70.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}