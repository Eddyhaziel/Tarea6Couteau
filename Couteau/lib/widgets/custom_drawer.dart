import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  // Estado para controlar el hover de cada item
  final Map<String, bool> _hoverStatus = {
    'Predecir Género': false,
    'Predecir Edad': false,
    'Ver Universidades': false,
    'Ver Clima en RD': false,
    'Buscar Pokémon': false,
    'Noticias de WordPress': false,
    'Acerca de': false,
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],  // Fondo oscuro para todo el Drawer
        child: Column(
          children: [
            // Header del Drawer
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Color.fromARGB(128, 0, 0, 0), // Fondo oscuro para el texto
                  ),
                ),
              ),
            ),
            // Agregamos SingleChildScrollView para permitir desplazamiento
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _navItem(context, 'Predecir Género', '/gender', Icons.person),
                    _navItem(context, 'Predecir Edad', '/age', Icons.calendar_today),
                    _navItem(context, 'Ver Universidades', '/universities', Icons.school),
                    _navItem(context, 'Ver Clima en RD', '/weather', Icons.wb_sunny),
                    _navItem(context, 'Buscar Pokémon', '/pokemon', Icons.pets),
                    _navItem(context, 'Noticias de WordPress', '/news', Icons.article),
                    _navItem(context, 'Acerca de', '/about', Icons.info),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para cada item del Drawer con efectos hover y click
  Widget _navItem(BuildContext context, String title, String route, IconData icon) {
    return MouseRegion(
      onEnter: (_) => _onHover(true, title),  // Efecto hover al entrar
      onExit: (_) => _onHover(false, title), // Efecto hover al salir
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route); // Navegar a la página correspondiente
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),  // Efecto suave de transición
          decoration: BoxDecoration(
            color: _hoverStatus[title]! ? Colors.grey[700] : Colors.transparent, // Efecto hover
            borderRadius: BorderRadius.circular(8),  // Bordes redondeados
          ),
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Reducido aún más el padding
          child: ListTile(
            leading: Icon(icon, color: Colors.white),  // Íconos en blanco
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Tamaño de fuente más pequeño
              ), 
            ),
          ),
        ),
      ),
    );
  }

  // Actualiza el estado del hover solo en el item seleccionado
  void _onHover(bool hover, String title) {
    setState(() {
      _hoverStatus[title] = hover;
    });
  }
}
