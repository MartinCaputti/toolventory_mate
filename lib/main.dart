import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase
import 'views/catalog_page.dart'; // Importar CatalogoPage
import 'views/category_page.dart'; // Importar CategoryPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de inicializar Flutter
  await Firebase.initializeApp(); // Inicializa Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario de Productos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Definir la pantalla principal
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Inventario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CategoryPage()), // Navegar a la pantalla de categorías
                );
              },
              child: Text('Ver Categorías'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CatalogoPage()), // Navegar al inventario completo de productos
                );
              },
              child: Text('Ver Inventario Completo'),
            ),
          ],
        ),
      ),
    );
  }
}
