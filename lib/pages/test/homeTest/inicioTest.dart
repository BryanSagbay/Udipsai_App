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

class _TestPageState extends State<TestPage> {
  final BluetoothService _bluetoothService = BluetoothService();
  bool _isConnected = false;
  String? _connectedDeviceAddress;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> _devices = [
    {"mac": "98:D3:71:FD:80:8B", "screen": (BluetoothService service, String mac) => Monotonia(bluetoothService: service, macAddress: mac)},
    {"mac": "98:D3:31:F6:5D:9D", "screen": (BluetoothService service, String mac) => TestRiel()},
    {"mac": "00:22:03:01:3C:45", "screen": (BluetoothService service, String mac) => TestPalanca()},
    {"mac": "98:D3:11:FC:3B:3D", "screen": (BluetoothService service, String mac) => TestTuercas()},
  ];

  @override
  void initState() {
    super.initState();
    _bluetoothService.init();
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _connectToDevice(String macAddress, String audioPath) async {
    var device = _devices.firstWhere((device) => device["mac"] == macAddress, orElse: () => {});
    if (device.isNotEmpty) {
      bool connected = await _bluetoothService.connectToDevice(macAddress);
      if (connected) {
        setState(() {
          _isConnected = true;
          _connectedDeviceAddress = macAddress;
        });
        await _playAudio(audioPath);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => device["screen"](_bluetoothService, macAddress)),
        ).then((_) async {
          await _bluetoothService.disconnectFromDevice();
          setState(() {
            _isConnected = false;
            _connectedDeviceAddress = null;
          });
        });
      } else {
        _showSnackBar('Error al conectar', Colors.red);
        await _playAudio('assets/audios/Error.mp3');
      }
    }
  }

  Future<void> _playAudio(String audioPath) async {
    await _audioPlayer.play(AssetSource(audioPath));
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
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
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/definilylogo.png',
                height: 250,
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
                  SizedBox(height: 10),
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
    return GestureDetector(
      onTap: () async {
        await _connectToDevice(macAddress, audioPath);
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
        child: Column(
          children: [
            Expanded(child: Image.asset(imagePath, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}