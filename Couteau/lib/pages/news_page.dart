import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_drawer.dart'; // Asegúrate de importar tu CustomDrawer

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  bool isLoading = true;
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  // Función para obtener los artículos de la API de Rolling Stone
  Future<void> fetchPosts() async {
    final url = Uri.parse('https://www.rollingstone.com/wp-json/wp/v2/posts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        posts = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Agregar el CustomDrawer al Scaffold
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Rolling Stone - Artículos'),
        backgroundColor: Colors.black,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final title = post['title']['rendered'];
                final excerpt = post['excerpt']['rendered'];
                final link = post['link'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _parseExcerpt(excerpt),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => _launchURL(Uri.parse(link)), // Cambié a Uri.parse
                  ),
                );
              },
            ),
    );
  }

  // Limpiar el HTML del extracto para mostrar solo texto
  String _parseExcerpt(String excerpt) {
    final document = RegExp(r'<[^>]*>', multiLine: true);
    return excerpt.replaceAll(document, '');
  }

  // Lanzar la URL cuando el usuario toque el artículo
  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) { // Cambié a canLaunchUrl
      await launchUrl(url); // Cambié a launchUrl
    } else {
      throw 'Could not launch $url';
    }
  }
}
