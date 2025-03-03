import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_drawer.dart'; // Asegúrate de importar tu CustomDrawer

class UniversityPage extends StatefulWidget {
  const UniversityPage({super.key});

  @override
  UniversityPageState createState() => UniversityPageState();
}

class UniversityPageState extends State<UniversityPage> {
  final TextEditingController _controller = TextEditingController();
  List universities = [];
  bool isLoading = false;

  Future<void> fetchUniversities() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=${_controller.text}'));

    if (response.statusCode == 200) {
      setState(() {
        universities = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agregar el CustomDrawer al Scaffold
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Universidades'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();  // Abre el Drawer (menú hamburguesa)
              },
            );
          },
        ),
        actions: [
          // Flecha de regreso hacia la pantalla anterior
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);  // Esto te lleva hacia atrás
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50], // Color de fondo azul claro
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Ingrese un país en inglés',
                  labelStyle: TextStyle(color: Colors.blue), // Color azul en la etiqueta
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchUniversities,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo del botón
              ),
              child: const Text('Buscar', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (universities.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: universities.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4.0, // Sombra para darle un aspecto de tarjeta
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          universities[index]['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(universities[index]['web_pages'][0]),
                        onTap: () => launchUrl(Uri.parse(universities[index]['web_pages'][0])),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
