import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/catalog_page.dart'; // Importa tu página del catálogo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario de Carpintería',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatalogoPage(), // Asegúrate de que esta es tu pantalla principal
    );
  }
}
