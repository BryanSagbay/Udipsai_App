import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Classic Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothHomePage(),
    );
  }
}

class BluetoothHomePage extends StatefulWidget {
  @override
  _BluetoothHomePageState createState() => _BluetoothHomePageState();
}

class _BluetoothHomePageState extends State<BluetoothHomePage> {
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _pairedDevices = [];
  List<Device> _discoveredDevices = [];
  Uint8List _receivedData = Uint8List(0);
  bool _isScanning = false;
  bool _isConnected = false;
  String? _connectedDeviceAddress;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    try {
      await _bluetoothClassicPlugin.initPermissions();
      _pairedDevices = await _bluetoothClassicPlugin.getPairedDevices();
      setState(() {});
    } catch (e) {
      print('Error al inicializar Bluetooth: $e');
    }
  }

  Future<void> _scanDevices() async {
    setState(() {
      _isScanning = true;
      _discoveredDevices = [];
    });

    _bluetoothClassicPlugin.onDeviceDiscovered().listen((device) {
      setState(() {
        _discoveredDevices.add(device);
      });
    });

    try {
      await _bluetoothClassicPlugin.startScan();
      await Future.delayed(Duration(seconds: 10));
      await _bluetoothClassicPlugin.stopScan();
    } catch (e) {
      print('Error al escanear dispositivos: $e');
    } finally {
      setState(() {
        _isScanning = false;
      });
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

      _bluetoothClassicPlugin.onDeviceDataReceived().listen((data) {
        setState(() {
          _receivedData = Uint8List.fromList([..._receivedData, ...data]);
        });
      });

      print('Conectado a $macAddress');
    } catch (e) {
      print('Error al conectar: $e');
    }
  }

  Future<void> _disconnectDevice() async {
    if (_isConnected && _connectedDeviceAddress != null) {
      try {
        await _bluetoothClassicPlugin.disconnect();
        setState(() {
          _isConnected = false;
          _connectedDeviceAddress = null;
          _receivedData = Uint8List(0);
        });
        print('Desconectado');
      } catch (e) {
        print('Error al desconectar: $e');
      }
    }
  }

  Future<void> _sendData(String message) async {
    if (_isConnected) {
      try {
        await _bluetoothClassicPlugin.write(message);
        print('Enviado: $message');
      } catch (e) {
        print('Error al enviar datos: $e');
      }
    } else {
      print('No hay un dispositivo conectado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Classic Demo'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _isScanning ? null : _scanDevices,
            child: Text(_isScanning ? 'Escaneando...' : 'Escanear dispositivos'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _discoveredDevices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_discoveredDevices[index].name ?? 'Dispositivo sin nombre'),
                  subtitle: Text(_discoveredDevices[index].address),
                  onTap: () => _connectToDevice(_discoveredDevices[index].address),
                );
              },
            ),
          ),
          if (_isConnected)
            Column(
              children: [
                Text('Conectado a $_connectedDeviceAddress'),
                ElevatedButton(
                  onPressed: _disconnectDevice,
                  child: Text('Desconectar'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Mensaje a enviar'),
                  onSubmitted: (text) => _sendData(text),
                ),
                Text('Datos recibidos: ${String.fromCharCodes(_receivedData)}'),
              ],
            ),
        ],
      ),
    );
  }
}
