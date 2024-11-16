//components/product_card.dart

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Producto producto;

  ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(producto.imagenUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(producto.nombre,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Stock: ${producto.stock}',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
