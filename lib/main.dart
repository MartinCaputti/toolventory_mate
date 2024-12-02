//lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importa Firebase
import 'package:flutter_native_splash/flutter_native_splash.dart'; // splash screen
import 'views/catalog_page.dart'; // Importo las vistas
import 'views/category_page.dart';
import 'views/furniture_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Inicialización de Firebase
  await Firebase.initializeApp();

  // Inicia la aplicación
  runApp(MyApp());

  // Remueve la splash screen después de que la aplicación haya sido inicializada
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToolVentory Mate', // Título de la aplicación
      // Defino el tema de la aplicación
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(
            125, 79, 51, 0.83), // Color primario para los títulos
        scaffoldBackgroundColor:
            Colors.transparent, // Hacemos el fondo transparente
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color.fromRGBO(125, 79, 51, 0.83), // Fondo del AppBar
          iconTheme: IconThemeData(
              color: Color.fromRGBO(
                  217, 149, 67, 1)), // Color de los iconos del AppBar
          titleTextStyle: TextStyle(
            color:
                Color.fromRGBO(248, 201, 143, 1), // Color del texto del AppBar
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFF2D0A7), // Fondo del BottomNavigationBar
          selectedItemColor: Color(0xFF734429), // Color del ítem seleccionado
          unselectedItemColor:
              Color(0xFFB5838D), // Color de los ítems no seleccionados
          selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold), // Estilo del texto seleccionado
          unselectedLabelStyle: TextStyle(
              fontWeight:
                  FontWeight.normal), // Estilo del texto no seleccionado
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF734429), // Color del botón flotante
          foregroundColor: Color.fromRGBO(
              217, 149, 67, 1), // Color del icono del botón flotante
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF734429), // Fondo de botones elevados
            foregroundColor: Colors.white, // Texto de botones elevados
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Color(0xFF734429)), // Color de texto principal
          bodyMedium:
              TextStyle(color: Color(0xFF734429)), // Color de texto secundario
          titleLarge: TextStyle(
            color: Color.fromRGBO(125, 79, 51, 0.83),
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF734429), // Color primario
          secondary: const Color(0xFFB5838D), // Color secundario
        ),
      ),
      home: HomePage(), // Definir la pantalla principal
      routes: {
        '/furniturePage': (context) => FurniturePage(), // Ruta nombrada
      },
    );
  }
}

// Clase para la pantalla principal de la aplicación
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// Estado de la pantalla principal
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice de la vista seleccionada

  // Lista de widgets para cada opción del BottomNavigationBar
  static final List<Widget> _widgetOptions = <Widget>[
    CategoryPage(),
    CatalogoPage(),
    FurniturePage(),
  ];

  // Método para manejar el tap en los ítems del BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToolVentory Mate'), // Título del AppBar
        backgroundColor: const Color.fromARGB(
            255, 123, 77, 49), // Mantiene el color del AppBar
        elevation: 0, // Removemos la sombra del AppBar para unificar el color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF734429), // Color inicial del degradado
              Color(0xFFF2D0A7), // Color final del degradado
            ],
          ),
        ),
        child: _widgetOptions
            .elementAt(_selectedIndex), // Muestra la vista seleccionada
      ),
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
            label: 'Muebles',
          ),
        ],
        currentIndex: _selectedIndex, // Índice actual
        selectedItemColor: Theme.of(context)
            .bottomNavigationBarTheme
            .selectedItemColor, // Color del ítem seleccionado
        unselectedItemColor: Theme.of(context)
            .bottomNavigationBarTheme
            .unselectedItemColor, // Color de los ítems no seleccionados
        onTap: _onItemTapped, // Callback al tocar un ítem
      ),
    );
  }
}
