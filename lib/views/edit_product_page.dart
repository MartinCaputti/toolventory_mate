// lib/views/edit_product_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import '../models/category.dart';

class EditProductPage extends StatefulWidget {
  final Producto producto;
  EditProductPage({required this.producto});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _imagenURLController;
  late TextEditingController _stockController;
  late TextEditingController _descripcionController;
  final ProductController _controller = ProductController();
  String? _selectedCategory; // Para almacenar la categoría seleccionada

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto.nombre);
    _imagenURLController =
        TextEditingController(text: widget.producto.imagenURL);
    _stockController =
        TextEditingController(text: widget.producto.stock.toString());
    _descripcionController =
        TextEditingController(text: widget.producto.descripcion);
    _selectedCategory = widget
        .producto.categoria; // Inicializa con la categoría actual del producto
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final updatedProduct = Producto(
        id: widget.producto.id,
        nombre: _nombreController.text,
        imagenURL: _imagenURLController.text,
        stock: int.parse(_stockController.text),
        descripcion: _descripcionController.text,
        categoria: _selectedCategory!, // Incluye la categoría seleccionada
      );
      await _controller.updateProduct(updatedProduct.id!, updatedProduct);
      Navigator.pop(context); // Volver a la página anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
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
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagenURLController,
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
                keyboardType: TextInputType.number,
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
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categorias')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  var categorias = snapshot.data!.docs.map((doc) {
                    return Categoria(
                      id: doc.id,
                      nombre: doc['nombre'],
                      imagenURL: doc['imagenURL'],
                    );
                  }).toList();
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Categoría'),
                    value: _selectedCategory,
                    items: categorias.map((categoria) {
                      return DropdownMenuItem(
                        value: categoria.nombre,
                        child: Text(categoria.nombre),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccione una categoría';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text('Actualizar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
