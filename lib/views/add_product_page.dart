//lib/views/add_product_page.dart

import 'package:flutter/material.dart';
import '../components/product_form.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class AddProductPage extends StatelessWidget {
  final ProductController _productController = ProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
        backgroundColor:
            const Color.fromARGB(255, 123, 77, 49), // Color del AppBar
      ),
      body: Container(
        color: Color(0xFFF2D0A7), // Color liso claro para el fondo
        child: ProductForm(
          onSave: (producto) async {
            await _productController.addProduct(producto);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Producto agregado correctamente.')),
            );
          },
        ),
      ),
    );
  }
}
