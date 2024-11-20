//lib/components/product_card.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import 'stock_controls.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final Producto producto;
  final ProductController controller;
  ProductCard({required this.producto, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: ProductImage(
                        imagenURL: producto
                            .imagenURL), // Utiliza el widget ProductImage
                  ),
                ),
              ),
            ),
          ),
          // Nombre del producto
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              producto.nombre,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          //Stock
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: StockControls(
              // Utiliza mi widget StockControls
              producto: producto,
              controller: controller,
              onStockChanged: (newStock) {},
            ),
          ),
          // Descripción del producto
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              producto.descripcion ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
