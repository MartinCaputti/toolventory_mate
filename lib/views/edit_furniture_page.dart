//lib/views/edit_furniture_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/furniture.dart';
import '../controllers/furniture_controller.dart';
import '../components/necessary_products_field.dart'; // Importar el componente

class EditFurniturePage extends StatefulWidget {
  final Mueble mueble;

  EditFurniturePage({required this.mueble});

  @override
  _EditFurniturePageState createState() => _EditFurniturePageState();
}

class _EditFurniturePageState extends State<EditFurniturePage> {
  final _formKey = GlobalKey<FormState>();
  final FurnitureController _furnitureController = FurnitureController();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _imagenURLController;
  late TextEditingController _stockController;

  final Map<String, Map<String, dynamic>> _productosNecesarios = {};
  final Map<String, String> _productosExistentes = {};

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.mueble.nombre);
    _descripcionController =
        TextEditingController(text: widget.mueble.descripcion);
    _imagenURLController = TextEditingController(text: widget.mueble.imagenURL);
    _stockController =
        TextEditingController(text: widget.mueble.stock.toString());

    // Inicializar _productosNecesarios con los productos del mueble existente
    _productosNecesarios.addAll(widget.mueble.productosNecesarios);
    _loadExistingProducts();
  }

  Future<void> _loadExistingProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('productos').get();
    setState(() {
      for (var doc in querySnapshot.docs) {
        _productosExistentes[doc.id] = doc['nombre'].toString();
      }
    });
  }

  Future<void> _saveMueble() async {
    if (_formKey.currentState!.validate()) {
      Mueble updatedMueble = Mueble(
        id: widget.mueble.id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        productosNecesarios: _productosNecesarios,
        imagenURL: _imagenURLController.text,
        stock: int.tryParse(_stockController.text) ?? widget.mueble.stock,
      );

      await _furnitureController.updateMueble(updatedMueble.id, updatedMueble);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mueble actualizado correctamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Mueble'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagenURLController,
                decoration: InputDecoration(labelText: 'URL de Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una URL de imagen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el stock';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Productos Necesarios',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ProductosNecesariosField(
                productosNecesarios: _productosNecesarios,
                productosExistentes: _productosExistentes,
                onChanged: (productosNecesarios) {
                  setState(() {
                    _productosNecesarios.addAll(productosNecesarios);
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveMueble,
                child: Text('Guardar Mueble'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
