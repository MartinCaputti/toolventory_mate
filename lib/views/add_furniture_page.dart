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
      ),
      body: FurnitureForm(
        onSave: (mueble) async {
          await _furnitureController.addMueble(mueble);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mueble agregado correctamente.')),
          );
        },
      ),
    );
  }
}
