//lib/views/add_product_page.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _imagenUrlController = TextEditingController();
  final _stockController = TextEditingController();
  final _descripcionController = TextEditingController();
  final ProductController _controller = ProductController();

  void _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final producto = Producto(
        nombre: _nombreController.text,
        imagenURL: _imagenUrlController.text,
        stock: int.parse(_stockController.text),
        descripcion: _descripcionController.text,
      );
      await _controller.addProduct(producto);
      Navigator.pop(context); // Volver a la página anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Producto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  // Validación del campo
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                //Sigo trabajando con URLs para Imagenes
                controller: _imagenUrlController,
                decoration: InputDecoration(labelText: 'URL de la Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la URL de la imagen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType
                    .number, //// Tipo de teclado para ingresar números
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la cantidad de stock';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('Añadir Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
