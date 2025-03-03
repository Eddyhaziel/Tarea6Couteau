import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_drawer.dart'; // Asegúrate de importar tu CustomDrawer

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  WeatherPageState createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  bool isLoading = false;
  String temperature = '';
  String description = '';
  String iconUrl = '';
  final String city = 'Santo Domingo';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    // REEMPLAZA 'YOUR_API_KEY' CON TU CLAVE DE API DE WEATHERAPI.
    const String apiKey = '443a4980d7024cafb66171833250303';
    final String url =
        'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&lang=es';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      double temp = data['current']['temp_c']; // Usamos 'temp_c' para obtener la temperatura en °C
      String desc = data['current']['condition']['text']; // Descripción del clima
      String icon = data['current']['condition']['icon']; // Icono del clima

      setState(() {
        temperature = temp.toStringAsFixed(1);
        description = desc;
        iconUrl = 'https:$icon'; // URL del icono
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        description = 'Error al obtener el clima';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agregar el CustomDrawer al Scaffold
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Clima en RD'),
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
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (iconUrl.isNotEmpty)
                    Image.network(
                      iconUrl,
                      width: 100,
                      height: 100,
                    ),
                  const SizedBox(height: 10),
                  Text(
                    '$temperature °C',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
      ),
    );
  }
}
