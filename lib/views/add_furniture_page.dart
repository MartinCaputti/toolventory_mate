//lib/views/add_furniture_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/furniture_controller.dart';
import '../models/furniture.dart';
import '../models/product.dart';
import '../components/necessary_products_field.dart'; // Importar desde components

class AddFurniturePage extends StatefulWidget {
  @override
  _AddFurniturePageState createState() => _AddFurniturePageState();
}

class _AddFurniturePageState extends State<AddFurniturePage> {
  final _formKey = GlobalKey<FormState>();
  final FurnitureController _furnitureController = FurnitureController();
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('productos');

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _imagenURLController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final Map<String, Map<String, dynamic>> _productosNecesarios = {};
  final Map<String, String> _productosExistentes = {};

  @override
  void initState() {
    super.initState();
    _loadExistingProducts();
  }

  Future<void> _loadExistingProducts() async {
    QuerySnapshot querySnapshot = await _productCollection.get();
    setState(() {
      for (var doc in querySnapshot.docs) {
        _productosExistentes[doc.id] = doc['nombre'].toString();
      }
    });
  }

  Future<void> _saveFurniture() async {
    if (_formKey.currentState!.validate()) {
      bool productsValid = true;
      for (var entry in _productosNecesarios.entries) {
        if (!_productosExistentes.containsKey(entry.key)) {
          productsValid = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Producto con ID "${entry.key}" no existe.'),
              backgroundColor: Colors.red,
            ),
          );
          break;
        }
      }

      if (productsValid) {
        Mueble nuevoMueble = Mueble(
          id: '',
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          productosNecesarios: _productosNecesarios,
          imagenURL: _imagenURLController.text,
          stock: int.tryParse(_stockController.text) ?? 0,
        );

        await _furnitureController.addMueble(nuevoMueble);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Mueble'),
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
                    return 'INGRESE EL NOMBRE ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagenURLController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la URL de la imagen AQUI';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock Inicial'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indique stock inicial';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Productos necesarios',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              ProductosNecesariosField(
                productosNecesarios: _productosNecesarios,
                productosExistentes: _productosExistentes,
                onChanged: (necessaryProducts) {
                  setState(() {
                    _productosNecesarios.addAll(necessaryProducts);
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveFurniture,
                child: Text('Guardar Mueble'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
