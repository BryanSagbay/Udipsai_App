import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hc05_udipsai/pages/paciente/selectPaciente/selectPacientes.dart';
import 'package:hc05_udipsai/pages/login/login.dart';
import 'package:hc05_udipsai/pages/paciente/crudPaciente/pacienteHome.dart';
import 'package:hc05_udipsai/pages/settings/settings.dart';
import 'package:hc05_udipsai/pages/test/homeTest/inicioTest.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _aguilaSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Animación de entrada y salida en 3 segundos
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0.2, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _aguilaSlideAnimation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startAnimationLoop();
  }

  void _startAnimationLoop() async {
    while (mounted) {
      await _controller.forward(); // Aparece
      await Future.delayed(Duration(seconds: 3)); // Pausa visible
      await _controller.reverse(); // Desaparece
      await Future.delayed(Duration(seconds: 1)); // Pausa antes de repetir
    }
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          children: [
            Image.asset(
              'lib/images/definilylogo.png',
              height: 230,
            ),
            SizedBox(width: 20),
            Spacer(),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/fondo.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.height * 0.3,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: Text(
                      "Universidad Católica \n          de Cuenca",
                      style: TextStyle(
                        fontSize: 53,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: Text(
                      "〉Sé un águila roja〈",
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.02,
            top: MediaQuery.of(context).size.height * - 0.10,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _aguilaSlideAnimation,
                child: Image.asset(
                  'lib/images/aguila.png',
                  width: 680,
                  height: 680,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_ios, color: Colors.white),
          Expanded(child: _buildCarousel(context)),
          Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return SizedBox(
      height: 60,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.3),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildCarouselItem(context, index);
        },
      ),
    );
  }

  Widget _buildCarouselItem(BuildContext context, int index) {
    final List<Map<String, dynamic>> buttons = [
      {"icon": "lib/icons/gear-wide-connected.svg", "text": "My Account", "action": () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()))},
      {"icon": "lib/icons/person-rolodex.svg", "text": "Pacientes", "action": () => Navigator.push(context, MaterialPageRoute(builder: (context) => PacientesScreen()))},
      {"icon": "lib/icons/menu-down.svg", "text": "Tests", "action": () => Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionPacientePage(onPacienteSeleccionado: (pacienteId, pacienteNombre, pacienteApellido) => Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage(pacienteId: pacienteId, pacienteNombre: pacienteNombre, pacienteApellido: pacienteApellido))))))},
      {"icon": "lib/icons/pc-display.svg", "text": "Soporte TI", "action": () {}},
      {"icon": "lib/icons/box-arrow-left.svg", "text": "Logout", "action": () => signUserOut(context)},
    ];

    final button = buttons[index];
    return GestureDetector(
      onTap: button["action"],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            button["icon"],
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(height: 3),
          Text(
            button["text"],
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
