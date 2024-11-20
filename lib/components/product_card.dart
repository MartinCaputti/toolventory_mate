//lib/components/product_card.dart

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';
import 'stock_controls.dart'; // Importar el widget StockControls
import 'product_image.dart'; // Importar el nuevo widget ProductImage

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
          // Imagen del Producto
          Expanded(
            child: Container(
              height: 150.0, // Altura fija para la imagen
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: ProductImage(
                    imagenURL:
                        producto.imagenURL), // Utiliza el widget ProductImage
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              producto.nombre,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Descripción del Producto
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                // Muestra un diálogo con la descripción completa cuando se toca
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(producto.nombre),
                      content: SingleChildScrollView(
                        child: Text(producto.descripcion ?? ''),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                producto.descripcion ?? '',
                maxLines: 2, // Limita el texto a dos líneas
                overflow: TextOverflow
                    .ellipsis, // Añade "..." al final del texto truncado
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ),
          // Controles de Stock
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: StockControls(
              producto: producto,
              controller: controller,
              onStockChanged: (newStock) {
                print("cambio el stock");
              },
            ),
          ),
          // Muestra la Categoría del Producto
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Categoría:',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  producto.categoria, // Muestra la categoría del producto
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 68, 67, 67)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
