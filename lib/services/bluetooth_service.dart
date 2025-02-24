import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  BluetoothDevice? connectedDevice;

  Future<void> connectToDevice(String macAddress) async {
    try {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      FlutterBluePlus.scanResults.listen((List<ScanResult> results) async {
        for (ScanResult result in results) {
          if (result.device.remoteId.str == macAddress) {
            // Se encontró el dispositivo
            await FlutterBluePlus.stopScan(); // Detener escaneo
            await result.device.connect(); // Conectar al dispositivo
            connectedDevice = result.device;
            print('✅ Conectado a ${result.device.localName}');
            return;
          }
        }
      });

    } catch (e) {
      print("❌ Error al conectar: $e");
    }
  }

  Future<void> disconnectDevice() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      print('🔌 Desconectado de ${connectedDevice!.localName}');
      connectedDevice = null;
    }
  }
}
