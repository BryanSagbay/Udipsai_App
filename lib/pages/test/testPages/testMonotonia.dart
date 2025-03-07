import 'package:flutter/material.dart';
import 'package:hc05_udipsai/services/bluetoothService.dart';

class Monotonia extends StatefulWidget {
  final BluetoothService bluetoothService;
  final String macAddress;

  const Monotonia({
    super.key,
    required this.bluetoothService,
    required this.macAddress,
  });

  @override
  State<Monotonia> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<Monotonia> {
  final TextEditingController _controller = TextEditingController();
  String _receivedData = "";

  String? _selectedOption;
  final List<String> _options = ['Aleatoriamente', 'Horario', 'Antihorario'];
  bool _isDropdownEnabled = false;
  bool _areButtonsEnabled = false;
  bool _isPlayPressed = false;

  @override
  void initState() {
    super.initState();

    // Configurar el callback para recibir datos
    widget.bluetoothService.onDataReceivedCallback = (String data) {
      setState(() {
        _receivedData += data;
      });
    };
  }

  @override
  void dispose() {
    widget.bluetoothService.disconnectFromDevice();
    widget.bluetoothService.onDataReceivedCallback = null;
    super.dispose();
  }

  // Función para habilitar el Dropdown al presionar el botón "Play"
  void _enableDropdown() {
    setState(() {
      _isPlayPressed = true;
      _isDropdownEnabled = true; // Habilitar el Dropdown
    });
  }

  // Función para cancelar (envía 'S' al Bluetooth)
  void _cancel() {
    widget.bluetoothService.sendData('S');
    setState(() {
      _isPlayPressed = false;
      _isDropdownEnabled = false;
    });
  }

  // Enviar datos por Bluetooth
  void _sendBluetoothMessage(String message) {
    widget.bluetoothService.sendData(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test de Monotonia"),
        backgroundColor: Colors.white70, // Color personalizado para AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            // Primera columna (Botones)
            Expanded(
              flex: 2, // Esto hará que la columna 1 ocupe más espacio
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centrar los botones
                children: [
                  // Botones para enviar mensajes al Bluetooth
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton("", Colors.red, "rojo"),
                          const SizedBox(width: 10),
                          _buildButton("", Colors.yellow, "amarillo"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton("", Colors.blue, "azul"),
                          const SizedBox(width: 10),
                          _buildButton("", Colors.green, "verde"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Segunda columna (Card con los resultados)
            Expanded(
              flex: 3, // Columna 2 será más ancha que la columna 1
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dropdown para seleccionar la opción (visible pero desactivado al inicio)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedOption,
                        hint: Text("Seleccione una opción"),
                        isExpanded: true,
                        onChanged: _isDropdownEnabled
                            ? (String? newValue) {
                          setState(() {
                            _selectedOption = newValue!;
                            _areButtonsEnabled = true;  // Habilitar los botones
                          });

                          // Enviar la opción seleccionada al Bluetooth
                          if (_selectedOption == 'Aleatoriamente') {
                            _sendBluetoothMessage('M1');
                          } else if (_selectedOption == 'Horario') {
                            _sendBluetoothMessage('M2');
                          } else if (_selectedOption == 'Antihorario') {
                            _sendBluetoothMessage('M3');
                          }
                        }
                            : null, // Desactivado si no se presionó "Play"
                        items: _options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Área para mostrar los datos recibidos
                  Expanded(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Text(
                              _receivedData.isNotEmpty
                                  ? _receivedData
                                  : "Esperando datos del dispositivo...",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
      // Botones flotantes
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FloatingActionButton(
            onPressed: _enableDropdown,
            backgroundColor: Colors.blue,
            child: Icon(Icons.play_arrow),
          ),
          if (_isPlayPressed) ...[
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _cancel,
              backgroundColor: Colors.red,
              child: Icon(Icons.stop),
            ),
          ]
        ],
      ),
    );
  }

  // Botón para enviar los mensajes de color
  Widget _buildButton(String text, Color color, String message) {
    return SizedBox(
      width: 210,  // Puedes ajustar el tamaño aquí
      height: 210,  // Puedes ajustar el tamaño aquí
      child: ElevatedButton(
        onPressed: _areButtonsEnabled
            ? () {
          _sendBluetoothMessage(message);  // Enviar el mensaje correspondiente al Bluetooth
          print("$text presionado");
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}
