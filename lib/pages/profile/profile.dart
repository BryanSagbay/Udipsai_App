import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hc05_udipsai/pages/paciente/selectPaciente/selectPacientes.dart';
import 'package:hc05_udipsai/pages/login/login.dart';
import 'package:hc05_udipsai/pages/paciente/crudPaciente/pacienteHome.dart';
import 'package:hc05_udipsai/pages/settings/settings.dart';
import 'package:hc05_udipsai/pages/test/homeTest/inicioTest.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de la página
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/fondo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Animación del águila
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeOut,
            top: 100,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child: AnimatedOpacity(
              duration: Duration(seconds: 2),
              opacity: 1.0,
              child: Image.asset(
                'lib/images/aguila.png',
                width: 300,
                height: 300,
              ),
            ),
          ),

          // Contenido principal
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 300), // Espacio para la animación del águila
                _buildCarousel(context), // Pasar el contexto aquí
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return SizedBox(
      height: 300, // Altura del carrusel
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.3), // Vista previa de los botones adyacentes
              itemCount: 5, // Número de botones
              itemBuilder: (context, index) {
                return _buildCarouselItem(context, index);
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int index) {
    final List<Map<String, dynamic>> buttons = [
      {
        "icon": "lib/icons/gear-wide-connected.svg",
        "text": "My Account",
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
        },
      },
      {
        "icon": "lib/icons/person-rolodex.svg",
        "text": "Pacientes",
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PacientesScreen()),
          );
        },
      },
      {
        "icon": "lib/icons/menu-down.svg",
        "text": "Tests",
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeleccionPacientePage(
                onPacienteSeleccionado: (pacienteId, pacienteNombre, pacienteApellido) {
                  print('Redirigiendo a TestPage con paciente: $pacienteNombre $pacienteApellido');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestPage(
                        pacienteId: pacienteId,
                        pacienteNombre: pacienteNombre,
                        pacienteApellido: pacienteApellido,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      },
      {
        "icon": "lib/icons/pc-display.svg",
        "text": "Soporte TI",
        "action": () {},
      },
      {
        "icon": "lib/icons/box-arrow-left.svg",
        "text": "Logout",
        "action": () => signUserOut(context),
      },
    ];

    final button = buttons[index];
    return GestureDetector(
      onTap: button["action"],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            button["icon"],
            width: 50,
            height: 50,
          ),
          SizedBox(height: 10),
          Text(
            button["text"],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Asegura que el texto sea visible sobre cualquier fondo
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 0 ? Colors.blue : Colors.grey, // Cambia el color según la página activa
          ),
        );
      }),
    );
  }
}
