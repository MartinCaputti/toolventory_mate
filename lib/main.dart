//lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase
import 'views/catalog_page.dart'; // Importar CatalogoPage
import 'views/category_page.dart'; // Importar CategoryPage
import 'views/furniture_page.dart'; // Importar FurniturePage

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice de la vista seleccionada

  static final List<Widget> _widgetOptions = <Widget>[
    CategoryPage(),
    CatalogoPage(),
    FurniturePage(), // Añadir la página de muebles
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Inventario'),
      ),
      body: _widgetOptions
          .elementAt(_selectedIndex), // Muestra la vista seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chair),
            label: 'Muebles', // Añadir un ítem para la página de muebles
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
