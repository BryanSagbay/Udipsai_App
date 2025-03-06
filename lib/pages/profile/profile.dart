import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hc05_udipsai/pages/paciente/selectPaciente/selectPacientes.dart';
import 'package:hc05_udipsai/pages/login/login.dart';
import 'package:hc05_udipsai/pages/paciente/crudPaciente/pacienteHome.dart';
import 'package:hc05_udipsai/pages/test/homeTest/inicioTest.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Importar el paquete

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _aguilaSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
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
      await _controller.forward();
      await Future.delayed(Duration(seconds: 3));
      await _controller.reverse();
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void signUserOut(BuildContext context) async {
    // Mostrar alerta de confirmación personalizada
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide, // Animación de la alerta
      title: 'Cerrar sesión',
      desc: '¿Estás seguro de que deseas salir?',
      btnCancelOnPress: () {
        // No hacer nada si el usuario cancela
      },
      btnOkOnPress: () async {
        // Cerrar sesión y redirigir al inicio
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
      btnCancelText: 'Cancelar', // Texto del botón Cancelar
      btnOkText: 'Sí, salir', // Texto del botón OK
      btnCancelColor: Colors.red, // Color del botón Cancelar
      btnOkColor: Colors.green, // Color del botón OK
      buttonsBorderRadius: BorderRadius.circular(10), // Bordes redondeados para los botones
      padding: EdgeInsets.all(20), // Padding interno del diálogo
      dialogBackgroundColor: Colors.white, // Fondo del diálogo
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      descTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          children: [
            Image.asset(
              'assets/images/definilylogo.png',
              height: 230,
            ),
            SizedBox(width: 20),
            Spacer(),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/box-arrow-left.svg',
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              onPressed: () => signUserOut(context),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Fondo de pantalla ajustado
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido del texto y la águila
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
            top: MediaQuery.of(context).size.height * -0.10,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SlideTransition(
                position: _aguilaSlideAnimation,
                child: Image.asset(
                  'assets/images/aguila.png',
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
      height: 80, // Establece una altura fija para el footer
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFooterButton(context, "assets/icons/person-rolodex.svg", "Pacientes", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PacientesScreen()));
          }),
          _buildFooterButton(context, "assets/icons/menu-down.svg", "Tests", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionPacientePage(onPacienteSeleccionado: (pacienteId, pacienteNombre, pacienteApellido) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage(pacienteId: pacienteId, pacienteNombre: pacienteNombre, pacienteApellido: pacienteApellido)));
            })));
          }),
          _buildFooterButton(context, "assets/icons/pc-display.svg", "Soporte TI", () {}),
        ],
      ),
    );
  }

  Widget _buildFooterButton(BuildContext context, String iconPath, String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(height: 3),
          Text(
            text,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}