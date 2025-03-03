import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_drawer.dart'; // Asegúrate de importar tu CustomDrawer

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  AgePageState createState() => AgePageState();
}

class AgePageState extends State<AgePage> {
  final TextEditingController _nameController = TextEditingController();
  String _ageMessage = '';
  int? _age;
  String _imagePath = '';

  Future<void> fetchAge() async {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      int? age = data['age'];

      setState(() {
        _age = age;
        if (age == null) {
          _ageMessage = "No se pudo determinar la edad.";
          _imagePath = '';
        } else if (age < 18) {
          _ageMessage = "Eres joven (Menos de 18 años).";
          _imagePath = 'assets/images/joven.jpg';
        } else if (age < 60) {
          _ageMessage = "Eres adulto (18 - 59 años).";
          _imagePath = 'assets/images/adulto.jpg';
        } else {
          _ageMessage = "Eres anciano (60+ años).";
          _imagePath = 'assets/images/anciano.png';
        }
      });
    } else {
      setState(() {
        _ageMessage = "Error al obtener la edad.";
        _imagePath = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agregar el CustomDrawer al Scaffold
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Predicción de Edad'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Introduce un nombre para predecir la edad:',
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
                onPressed: fetchAge,
                child: const Text('Predecir Edad'),
              ),
              const SizedBox(height: 20),
              Text(
                _age != null
                    ? 'Edad estimada: $_age años\n$_ageMessage'
                    : _ageMessage,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (_imagePath.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Image.asset(_imagePath, width: 150),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
