import 'package:flutter/material.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  NavBarState createState() => NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Altura del AppBar
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Home',
        style: TextStyle(color: Colors.white), // Cambiar el color del texto a blanco
      ),
      backgroundColor: Colors.grey[900], // Fondo oscuro para el AppBar
      actions: MediaQuery.of(context).size.width > 800
          ? [] // No mostramos nada en pantallas grandes
          : [], // También dejamos vacío el área de acciones para evitar que se muestren elementos del menú
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // Icono en blanco
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Abre el Drawer al hacer clic
          },
        ),
      ),
    );
  }
}
