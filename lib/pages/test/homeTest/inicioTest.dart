import 'package:flutter/material.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/test2.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/test3.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/test4.dart';
import 'package:hc05_udipsai/pages/test/Monotonia/testMonotonia.dart';

class TestPage extends StatelessWidget {
  final String pacienteId;
  final String pacienteNombre;
  final String pacienteApellido;

  TestPage(
      {required this.pacienteId, required this.pacienteNombre, required this.pacienteApellido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tests'),
      ),
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
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(text: "PACIENTE SELECCIONADO: \n"),
                      ],
                    ),
                  ),
                  Text(
                    "$pacienteNombre $pacienteApellido",
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
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 2.5,
                children: [
                  _buildTestButton(
                      'Test 1', pacienteNombre, pacienteApellido, context),
                  _buildTestButton(
                      'Test 2', pacienteNombre, pacienteApellido, context),
                  _buildTestButton(
                      'Test 3', pacienteNombre, pacienteApellido, context),
                  _buildTestButton(
                      'Test 4', pacienteNombre, pacienteApellido, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, String nombre, String apellido,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        onPressed: () {
          Widget nextPage;

          switch (label) {
            case 'Test 1':
              nextPage = Monotonia();
              break;
            case 'Test 2':
              nextPage = test2();
              break;
            case 'Test 3':
              nextPage = test3();
              break;
            case 'Test 4':
              nextPage = test4();
              break;
            default:
              nextPage = Monotonia();
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(150, 150),
        ),
        child: Text(label),
      ),
    );
  }
}