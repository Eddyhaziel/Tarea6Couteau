import 'package:flutter/material.dart';
import 'pages/gender_page.dart';
import 'pages/age_page.dart';
import 'pages/universities_page.dart';
import 'pages/weather_page.dart';
import 'pages/pokemon_page.dart';
import 'pages/news_page.dart';
import 'pages/about_page.dart';
import 'widgets/navbar.dart';
import 'widgets/custom_drawer.dart';

void main() {
  runApp(CouteauApp());
}

class CouteauApp extends StatelessWidget {
  const CouteauApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Couteau App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/gender': (context) => const GenderPage(),
        '/age': (context) => AgePage(),
        '/universities': (context) => UniversityPage(),
        '/weather': (context) => WeatherPage(),
        '/pokemon': (context) => PokemonPage(),
        '/news': (context) => NewsPage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Image.asset(
                  'assets/images/herramienta.jpg',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Bienvenid@ a Herramientas Disla',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ...[
                  {'route': '/gender', 'text': 'Predecir Género'},
                  {'route': '/age', 'text': 'Predecir Edad'},
                  {'route': '/universities', 'text': 'Ver Universidades'},
                  {'route': '/weather', 'text': 'Ver Clima en RD'},
                  {'route': '/pokemon', 'text': 'Buscar Pokémon'},
                  {'route': '/news', 'text': 'Noticias de WordPress'},
                  {'route': '/about', 'text': 'Acerca de'},
                ].map((button) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, button['route']!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text(button['text']!),
                  ),
                )).toList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
