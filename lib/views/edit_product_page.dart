// lib/views/edit_product_page.dart

import 'package:flutter/material.dart';
import '../components/product_form.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class EditProductPage extends StatelessWidget {
  final Producto producto;
  final ProductController _productController = ProductController();

  EditProductPage({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto'),
      ),
      body: ProductForm(
        producto: producto,
        onSave: (updatedProducto) async {
          await _productController.updateProduct(updatedProducto);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Producto actualizado correctamente.')),
          );
        },
      ),
    );
  }
}
