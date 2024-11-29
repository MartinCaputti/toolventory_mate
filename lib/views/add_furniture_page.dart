//lib/views/add_furniture_page.dart
import 'package:flutter/material.dart';
import '../components/furniture_form.dart';
import '../models/furniture.dart';
import '../controllers/furniture_controller.dart';

class AddFurniturePage extends StatelessWidget {
  final FurnitureController _furnitureController = FurnitureController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Mueble'),
          backgroundColor:
              const Color.fromARGB(255, 123, 77, 49), // Color del AppBar
        ),
        body: Container(
          color: Color(0xFFF2D0A7), // Color liso claro para el fondo
          child: FurnitureForm(
            onSave: (mueble) async {
              await _furnitureController.addMueble(mueble);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mueble agregado correctamente.')),
              );
            },
          ),
        ));
  }
}
