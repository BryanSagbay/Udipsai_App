import 'dart:typed_data'; // Importar para Uint8List
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';

class BluetoothService {
  final BluetoothClassic _bluetooth = BluetoothClassic();
  int _deviceStatus = Device.disconnected;

  // Callback para notificar cuando llegan datos
  Function(String)? onDataReceivedCallback;

  Future<void> init() async {
    await _bluetooth.initPermissions();
    _bluetooth.onDeviceStatusChanged().listen((status) {
      _deviceStatus = status;
    });

    // Escuchar datos recibidos y notificar mediante el callback
    _bluetooth.onDeviceDataReceived().listen((Uint8List data) {
      if (onDataReceivedCallback != null) {
        onDataReceivedCallback!(String.fromCharCodes(data));
      }
    });
  }

  Future<bool> connectToDevice(String macAddress) async {
    try {
      await _bluetooth.connect(
        macAddress,
        "00001101-0000-1000-8000-00805f9b34fb",
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> disconnectFromDevice() async {
    if (_deviceStatus == Device.connected) {
      await _bluetooth.disconnect();
    }
  }

  Future<void> sendData(String message) async {
    if (_deviceStatus == Device.connected) {
      await _bluetooth.write(message);
    }
  }

  void dispose() {
    disconnectFromDevice();
  }
}