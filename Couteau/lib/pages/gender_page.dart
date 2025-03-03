import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_drawer.dart'; // Asegúrate de importar tu CustomDrawer

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  GenderPageState createState() => GenderPageState(); 
}

class GenderPageState extends State<GenderPage> { 
  final TextEditingController _nameController = TextEditingController();
  String _gender = '';
  Color _backgroundColor = Colors.white;

  Future<void> fetchGender() async {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    final url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _gender = data['gender'] ?? 'Desconocido';
        _backgroundColor = (_gender == 'male')
            ? Colors.blue
            : (_gender == 'female')
                ? Colors.pink
                : Colors.grey;
      });
    } else {
      setState(() {
        _gender = 'Error al obtener el género';
        _backgroundColor = Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agregar el CustomDrawer al Scaffold
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Predicción de Género'),
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
      body: Container(
        color: _backgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Introduce un nombre para predecir su género:',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchGender,
                  child: const Text('Predecir Género'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Género: $_gender',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
