import 'package:flutter/material.dart';

class test4 extends StatelessWidget {
  final String testName;

  test4({required this.testName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testName),
      ),
      body: Center(
        child: Text(
          'Detalles del test 4 asfasl',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
