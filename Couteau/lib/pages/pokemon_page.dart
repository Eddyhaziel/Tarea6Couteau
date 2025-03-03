import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_drawer.dart'; // Asegúrate de importar tu CustomDrawer

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  PokemonPageState createState() => PokemonPageState();
}

class PokemonPageState extends State<PokemonPage> {
  final TextEditingController _nameController = TextEditingController();
  String imageUrl = '';
  int baseExperience = 0;
  List<String> abilities = [];
  String message = '';

  // Función para obtener los datos del Pokémon ingresado
  Future<void> fetchPokemon() async {
    String name = _nameController.text.trim().toLowerCase();
    if (name.isEmpty) return;

    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Obtenemos la imagen (sprite), experiencia base y habilidades
      String spriteUrl = data['sprites']['front_default'];
      int baseExp = data['base_experience'];
      List<dynamic> abilitiesList = data['abilities'];
      List<String> abilityNames = abilitiesList.map((ability) {
        return ability['ability']['name'] as String;
      }).toList();

      setState(() {
        imageUrl = spriteUrl;
        baseExperience = baseExp;
        abilities = abilityNames;
        message = '';
      });
    } else {
      setState(() {
        message = 'No se encontró el Pokémon';
        imageUrl = '';
        baseExperience = 0;
        abilities = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agregar el CustomDrawer al Scaffold
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Información de Pokémon'),
        backgroundColor: Colors.blue,
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
            const Text(
              'Introduce el nombre de un Pokémon:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre del Pokémon',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchPokemon,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text('Buscar Pokémon', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(
                message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            if (imageUrl.isNotEmpty) ...[
              Image.network(
                imageUrl,
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              Text(
                'Experiencia Base: $baseExperience',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Habilidades: ${abilities.join(', ')}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
