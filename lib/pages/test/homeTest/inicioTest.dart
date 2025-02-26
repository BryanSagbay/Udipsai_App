import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/test2.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/test3.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/test4.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/testMonotonia.dart';

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
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
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
        appBar: AppBar(title: Text('Tests')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF930925),
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
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  children: [
                    _buildTestButton('Test 1', Monotonia(), "98:D3:71:FD:80:8B"),
                    _buildTestButton('Test 2', test2(), "MAC_ADDRESS_2"),
                    _buildTestButton('Test 3', test3(), "MAC_ADDRESS_3"),
                    _buildTestButton('Test 4', test4(), "MAC_ADDRESS_4"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, Widget nextPage, String macAddress) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: () async {
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
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: Size(150, 150),
        ),
        child: Text(label),
      ),
    );
  }
}