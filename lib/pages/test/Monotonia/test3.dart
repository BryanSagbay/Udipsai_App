import 'package:flutter/material.dart';

class test3 extends StatelessWidget {
  final String testName;

  test3({required this.testName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testName),
      ),
      body: Center(
        child: Text(
          'Detalles del $testName',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
