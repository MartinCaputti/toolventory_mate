//lib/components/product_form.dart

import 'package:flutter/material.dart';
import '../models/product.dart'; // Importa el modelo de producto
import '../controllers/product_controller.dart'; // Importa el controlador de productos
import '../models/category.dart'; // Importa el modelo de categoría
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

// Widget que define el formulario de productos
class ProductForm extends StatefulWidget {
  final Producto?
      producto; // Producto que se está editando, puede ser null para un nuevo producto
  final Function(Producto) onSave; // Callback para guardar el producto

  ProductForm({this.producto, required this.onSave});

  @override
  _ProductFormState createState() => _ProductFormState();
}

// Estado del formulario de productos
class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>(); // Clave del formulario
  final ProductController _productController =
      ProductController(); // Controlador de productos

  // Controladores de texto para los campos del formulario
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _imagenURLController;
  late TextEditingController _stockController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores de texto con los valores del producto si está presente
    _nombreController =
        TextEditingController(text: widget.producto?.nombre ?? '');
    _descripcionController =
        TextEditingController(text: widget.producto?.descripcion ?? '');
    _imagenURLController =
        TextEditingController(text: widget.producto?.imagenURL ?? '');
    _stockController =
        TextEditingController(text: widget.producto?.stock.toString() ?? '0');
    _selectedCategory = widget.producto?.categoria;
  }

  // Guarda el producto
  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      Producto nuevoProducto = Producto(
        id: widget.producto?.id ?? '',
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        imagenURL: _imagenURLController.text,
        stock: int.tryParse(_stockController.text) ?? 0,
        categoria: _selectedCategory!,
      );

      widget.onSave(
          nuevoProducto); // Llama al callback onSave con el nuevo producto
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
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
          // Campo desplegable para seleccionar la categoría
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('categorias').snapshots(),
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
          SizedBox(height: 16.0),
          // Botón para guardar el producto
          ElevatedButton(
            onPressed: _saveProduct,
            child: Text(widget.producto == null
                ? 'Agregar Producto'
                : 'Guardar Producto'),
          ),
        ],
      ),
    );
  }
}
