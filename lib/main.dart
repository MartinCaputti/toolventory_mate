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
        primaryColor: const Color(0xFF734429),
        scaffoldBackgroundColor: const Color(0xFFF2D0A7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF734429),
          iconTheme: IconThemeData(color: Color.fromRGBO(217, 149, 67, 1)),
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(248, 201, 143, 1),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFF2D0A7),
          selectedItemColor: Color(0xFF734429),
          unselectedItemColor: Color(
              0xFFB5838D), // Cambiar el color de los ítems no seleccionados
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
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
          bodyLarge: TextStyle(color: Color(0xFF734429)),
          bodyMedium: TextStyle(color: Color(0xFF734429)),
          titleLarge: TextStyle(
            color: Color(0xFF734429),
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF734429),
          secondary: const Color(0xFFB5838D),
        ),
      ),
      home: HomePage(), // Definir la pantalla principal
      routes: {
        '/furniturePage': (context) => FurniturePage(), // Ruta nombrada
      },
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
        title: const Text('Gestión de Inventario'),
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
            label: 'Muebles',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
