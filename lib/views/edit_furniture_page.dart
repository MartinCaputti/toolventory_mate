//lib/views/edit_furniture_page.dart
import 'package:flutter/material.dart';
import '../components/furniture_form.dart';
import '../models/furniture.dart';
import '../controllers/furniture_controller.dart';

class EditFurniturePage extends StatelessWidget {
  final Mueble mueble;
  final FurnitureController _furnitureController = FurnitureController();

  EditFurniturePage({required this.mueble});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Mueble'),
      ),
      body: FurnitureForm(
        mueble: mueble,
        onSave: (updatedMueble) async {
          await _furnitureController.updateMueble(updatedMueble);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mueble actualizado correctamente.')),
          );
        },
      ),
    );
  }
}
