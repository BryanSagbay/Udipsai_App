import 'package:flutter/material.dart';

class FavoriteProductsScreen extends StatelessWidget {
  const FavoriteProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Contenedor para los 4 botones en 2x2
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2, // 2 columnas
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.4,
                  children: [
                    ButtonCard(title: "Botón 1", icon: Icons.add),
                    ButtonCard(title: "Botón 2", icon: Icons.remove),
                    ButtonCard(title: "Botón 3", icon: Icons.star),
                    ButtonCard(title: "Botón 4", icon: Icons.access_alarm),
                  ],
                ),
              ),
            ),

            // Barra inferior de navegación
            BottomNavbar(),
          ],
        ),
      ),
    );
  }
}

class ButtonCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const ButtonCard({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          // Acción que deseas realizar al presionar el botón
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue), // Reducir el tamaño del ícono
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.blue)), // Reducir el tamaño del texto
          ],
        ),
      ),
    );
  }
}

class BottomNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }
}

