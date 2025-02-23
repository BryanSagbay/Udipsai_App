import 'package:flutter/material.dart';
import 'package:hc05_udipsai/services/firebase_service.dart';
import 'package:provider/provider.dart'; // Importa el paquete provider
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hc05_udipsai/pages/login/login.dart';
import 'package:hc05_udipsai/pages/profile/profile.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        // Provee el servicio de pacientes
        Provider<PacienteService>(
          create: (_) => PacienteService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return LoginPage();
            } else {
              return ProfileScreen();
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}